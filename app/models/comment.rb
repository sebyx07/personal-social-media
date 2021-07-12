# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id                 :bigint           not null, primary key
#  comment_type       :string           default("standard"), not null
#  content            :jsonb            not null
#  is_latest          :boolean          not null
#  signature          :binary           not null
#  sub_comments_count :bigint           default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  comment_counter_id :bigint           not null
#  parent_comment_id  :bigint
#  peer_id            :bigint           not null
#
# Indexes
#
#  index_comments_on_comment_counter_id  (comment_counter_id)
#  index_comments_on_parent_comment_id   (parent_comment_id)
#  index_comments_on_peer_id             (peer_id)
#
# Foreign Keys
#
#  fk_rails_...  (comment_counter_id => comment_counters.id)
#  fk_rails_...  (parent_comment_id => comments.id)
#  fk_rails_...  (peer_id => peers.id)
#
class Comment < ApplicationRecord
  PERMITTED_SUBJECT_CLASSES = %w(Post Comment)
  belongs_to :comment_counter, counter_cache: true
  delegate :subject_type, :subject_id, :subject, to: :comment_counter
  belongs_to :peer
  belongs_to :parent_comment, class_name: "Comment", optional: true, counter_cache: :sub_comments_count
  has_many :sub_comments, class_name: "Comment", foreign_key: :parent_comment_id, dependent: :nullify
  before_create :handle_update_latest

  has_many :reaction_counters, -> { order(reactions_count: :desc) }, as: :subject, dependent: :destroy
  has_many :reactions, through: :reaction_counters
  has_many :cache_reactions, -> { where(peer: Current.peer) }, dependent: :delete_all, as: :subject

  validate :check_parent_matches, on: :create, if: -> { parent_comment_id.present? }

  store :content, accessors: %i(message)
  validates :message, presence: true, length: { maximum: 1000 }, if: -> { standard? }

  str_enum :comment_type, %i(standard)
  validates :comment_type, presence: true
  validates :signature, presence: true
  validate :validate_signature

  has_one :cache_comment, -> do
    joins(<<-SQL
LEFT JOIN comments
ON cache_comments.peer_id = comments.peer_id
    SQL
         )
  end, foreign_key: :remote_comment_id

  has_many :cache_reactions, -> do
    joins(<<-SQL
LEFT JOIN comments
ON cache_reactions.peer_id = comments.peer_id AND cache_reactions.subject_type = 'RemotePost' AND cache_reactions.subject_id = comments.id
    SQL
         )
  end, dependent: :delete_all, as: :subject

  def is_valid_signature?
    true
  end

  def raw_signature
    CommentsService::RawSignature.new(self, peer)
  end

  private
    def check_parent_matches
      errors.add(:subject_type, "parent subject_type does not match") if parent_comment.subject_type != subject_type.to_s
      errors.add(:subject_id, "parent subject_id does not match") if parent_comment.subject_id != subject_id
    end

    def handle_update_latest
      CommentsService::HandleUpdateLatest.new(self).call!
    end

    def validate_signature
      signed_result = EncryptionService::SignedResult.from_str({
        message: raw_signature.hash.to_s,
        signature: signature
      }.with_indifferent_access)

      unless EncryptionService::VerifySignature.new(peer.verify_key).verify(signed_result)
        errors.add(:signature, "invalid")
      end
    end
end
