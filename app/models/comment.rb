# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id                 :bigint           not null, primary key
#  comment_type       :string           default("standard"), not null
#  content            :jsonb            not null
#  is_latest          :boolean          not null
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
  PERMITTED_SUBJECT_CLASSES = %w(Post)
  belongs_to :comment_counter
  delegate :subject_type, :subject_id, :subject, to: :comment_counter
  belongs_to :peer
  belongs_to :parent_comment, class_name: "Comment", optional: true, counter_cache: :sub_comments_count
  has_many :sub_comments, class_name: "Comment", foreign_key: :parent_comment_id, dependent: :nullify
  before_create :handle_update_latest

  validate :check_parent_matches, on: :create, if: -> { parent_comment_id.present? }

  store :content, accessors: %i(message)
  validates :message, presence: true, length: { maximum: 1000 }, if: -> { standard? }

  str_enum :comment_type, %i(standard)
  validates :comment_type, presence: true

  private
    def check_parent_matches
      errors.add(:subject_type, "parent subject_type does not match") if parent_comment.subject_type != subject_type.to_s
      errors.add(:subject_id, "parent subject_id does not match") if parent_comment.subject_id != subject_id
    end

    def handle_update_latest
      CommentsService::HandleUpdateLatest.new(self).call!
    end
end
