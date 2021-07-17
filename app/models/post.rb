# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text
#  post_type  :string           default("standard"), not null
#  signature  :binary           not null
#  status     :string           default("pending"), not null
#  views      :bigint           default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  validates :content, allow_nil: true, length: { maximum: 2000 }
  str_enum :status, %i(pending ready)
  str_enum :post_type, %i(standard)
  after_commit :propagate_to_peers, on: %i(create update), if: :propagate_to_peers?
  after_commit :propagate_to_peers_destroy, on: :destroy, if: :propagate_to_peers_destroy?
  before_update :update_remote_post, if: -> { post_type_changed? }
  after_create :create_self_remote_post
  before_save :generate_signature

  validates :post_type, presence: true
  if Rails.env.test?
    has_one :remote_post, -> { where(peer: Current.peer) }, foreign_key: :remote_post_id
  else
    has_one :remote_post, -> { where(peer: Current.peer) }, foreign_key: :remote_post_id, dependent: :destroy
  end
  has_many :reaction_counters, -> { order(reactions_count: :desc) }, as: :subject, dependent: :destroy
  has_many :reactions, through: :reaction_counters
  has_many :cache_reactions, -> { where(peer: Current.peer) }, dependent: :delete_all, as: :subject
  has_many :uploads, as: :subject, dependent: :destroy

  has_one :comment_counter, as: :subject, dependent: :destroy
  delegate :comments_count, to: :comment_counter, allow_nil: true
  has_many :comments, through: :comment_counter, source: :comments
  has_many :latest_comments, -> { where(is_latest: true) }, through: :comment_counter, source: :comments

  has_many :cache_comments, dependent: :delete_all, as: :subject

  class << self
    def allow_propagate_to_remote?
      Rails.env.production?
    end
  end

  def raw_signature
    initialize_timestamps
    PostsService::RawSignature.new(self, Current.peer)
  end

  def is_valid_signature?
    true
  end

  private
    def propagate_to_peers
      PostsWorker::PropagateNewPostWorker.perform_async(id)
    end

    def propagate_to_peers_destroy
      PostsWorker::PropagateDestroyPostWorker.perform_async(id)
    end

    def propagate_to_peers?
      ready? && self.class.allow_propagate_to_remote?
    end

    def propagate_to_peers_destroy?
      self.class.allow_propagate_to_remote?
    end

    def create_self_remote_post
      RemotePost.create!(peer: Current.peer, remote_post_id: id, post_type: post_type, show_in_feed: true)
    end

    def update_remote_post
      remote_post.update!(post_type: post_type)
      propagate_to_peers
    end

    def generate_signature
      self.signature = EncryptionService::Sign.new.sign_message(raw_signature.hash.to_s).signature
    end

    def initialize_timestamps
      return if created_at.present?
      self.created_at = Time.zone.now
      self.updated_at = created_at
    end
end
