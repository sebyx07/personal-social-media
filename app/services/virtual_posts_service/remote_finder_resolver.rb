# frozen_string_literal: true

module VirtualPostsService
  class RemoteFinderResolver
    attr_reader :remote_posts
    def initialize(remote_posts)
      @remote_posts = remote_posts.map do |r_post|
        VirtualPostsService::RemoteFinderRequest.new(r_post)
      end
    end

    def run!
      batch_runner = HttpService::ApiClientBatch.new(requests: real_remote_posts.map(&:api_client_request))
      batch_runner.run
    end

    def resolve_all
      remote_posts.map do |remote_post_requests|
        next remote_post_requests.api_client_request if remote_post_requests.is_remote_peer?

        remote_post_requests.local_post = real_local_posts.find do |post|
          post.id == remote_post_requests.remote_post.remote_post_id
        end
      end
    end

    private
      def real_remote_posts
        return @real_remote_posts if defined? @real_remote_posts
        @real_remote_posts = remote_posts.select(&:is_remote_peer?)
      end

      def real_local_posts
        return @real_local_posts if defined? @real_local_posts
        local_posts = remote_posts.select { |rp| !rp.is_remote_peer? }

        ids = local_posts.map do |rpost|
          rpost.remote_post.remote_post_id
        end

        @real_local_posts = Post.where(id: ids)
      end
  end
end
