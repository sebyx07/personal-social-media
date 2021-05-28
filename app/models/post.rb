# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text
#  status     :string           default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  validates :content, allow_nil: true, length: { maximum: 2000 }
  str_enum :status, %i(pending ready)
  after_commit :propagate_to_peers, on: %i(create update), if: -> { ready? }
  after_commit :propagate_to_peers_destroy, on: :destroy

  private
    def propagate_to_peers
      PostsWorker::PropagateNewPostWorker.perform_async(id)
    end

    def propagate_to_peers_destroy
      PostsWorker::PropagateDestroyPostWorker.perform_async(id)
    end
end
