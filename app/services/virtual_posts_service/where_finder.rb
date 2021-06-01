# frozen_string_literal: true

module VirtualPostsService
  class WhereFinder
    class Error < StandardError; end
    DEFAULT_LIMIT = 15

    attr_reader :pagination_params, :peer_id
    def initialize(pagination_params, peer_id)
      @pagination_params = pagination_params
      @peer_id = peer_id
    end

    def results
      if peer_id.present?
        handle_for_peer_id
      end
    end

    private
      def handle_local_posts(posts)
        p = Current.peer
        posts.map { |post| VirtualPost.new(post: post, peer: p) }
      end

      def handle_remote_requests(requests)
        p = Current.peer

        requests.filter_map do |result|
          next VirtualPost.new(post: result, peer: p) if result.is_a?(Post)
          next unless result.valid?

          peer = result.record.remote_post.peer
          next VirtualPost.new(request: result, peer: peer)
        end
      end

      def handle_for_peer_id
        if peer_id == Current.peer.id
          posts = LocalFinder.new(pagination_params: pagination_params).posts
          handle_local_posts(posts)
        else
          requests = RemoteFinder.new(pagination_params: pagination_params).requests
          handle_remote_requests(requests)
        end
      end
  end
end
