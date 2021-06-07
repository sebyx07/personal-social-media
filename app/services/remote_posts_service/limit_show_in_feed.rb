# frozen_string_literal: true

module RemotePostsService
  class LimitShowInFeed
    attr_reader :remote_post
    def initialize(remote_post)
      @remote_post = remote_post
    end

    def call
      if remote_post.standard?
        handle_standard
      end
    end

    private
      def handle_standard
        RemotePost.where(peer: remote_post.peer).where("created_at > ?", 24.hours.ago).count < 5
      end
  end
end
