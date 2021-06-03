# frozen_string_literal: true

module VirtualPostsService
  class RemoteFinderResolver
    attr_reader :remote_finder_requests
    def initialize(remote_posts)
      @remote_finder_requests = remote_posts.map do |r_post|
        VirtualPostsService::RemoteFinderRequest.new(r_post)
      end
    end

    def run!
      batch_runner = HttpService::ApiClientBatch.new(requests: optimized_remote_finder_requests.map(&:api_client_request))
      batch_runner.run
    end

    def resolve_all
      uniq_combined_requests = []
      res = []

      remote_finder_requests.each do |remote_post_requests|
        if remote_post_requests.is_remote_peer?
          next res << remote_post_requests.api_client_request if remote_post_requests.combined_request.blank?
          next if uniq_combined_requests.include?(remote_post_requests.combined_request)

          uniq_combined_requests << remote_post_requests.combined_request
          next res << remote_post_requests.combined_request.api_client_request
        end

        res << real_local_posts.find do |post|
          post.id == remote_post_requests.remote_post.remote_post_id
        end
      end

      res
    end

    private
      def real_remote_posts
        return @real_remote_posts if defined? @real_remote_posts
        @real_remote_posts = remote_finder_requests.select(&:is_remote_peer?)
      end

      def real_local_posts
        return @real_local_posts if defined? @real_local_posts
        local_posts = remote_finder_requests.select { |rp| !rp.is_remote_peer? }

        ids = local_posts.map do |rpost|
          rpost.remote_post.remote_post_id
        end

        @real_local_posts = Post.includes(:remote_post).where(id: ids)
      end

      def optimized_remote_finder_requests
        @optimized_remote_finder_requests ||= HttpService::StandardCombineRequests.new(real_remote_posts, "/posts/").call
      end
  end
end
