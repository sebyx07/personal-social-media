# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text
#  post_type  :string           default("standard"), not null
#  status     :string           default("pending"), not null
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
  validates :post_type, presence: true

  class << self
    def allow_propagate_to_remote?
      Rails.env.production?
    end
  end

  def remote_post
    @remote_post ||= RemotePost.find_by!(peer: Current.peer, remote_post_id: id)
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
      RemotePost.create!(peer: Current.peer, remote_post_id: id, post_type: post_type)
    end

    def update_remote_post
      remote_post.update!(post_type: post_type)
      propagate_to_peers
    end
end
