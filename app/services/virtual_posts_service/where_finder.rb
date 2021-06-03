# frozen_string_literal: true

module VirtualPostsService
  class WhereFinder
    class Error < StandardError; end
    DEFAULT_LIMIT = 15

    attr_reader :pagination_params, :peer_id, :post_type
    def initialize(pagination_params, post_type: :standard, peer_id: nil)
      @pagination_params = pagination_params
      @peer_id = peer_id
      @post_type = post_type
    end

    def results
      return handle_for_peer_id if peer_id.present?
      handle_mix
    end

    private
      def handle_local_posts(posts)
        posts.map { |post| VirtualPost.new(post: post, peer: Current.peer, remote_post: post.remote_post) }
      end

      def handle_remote_requests(requests)
        requests.filter_map do |result|
          next VirtualPost.new(post: result, peer: Current.peer, remote_post: result.remote_post) if result.is_a?(Post)
          next unless result.valid?

          peer = result.peer
          next VirtualPost.load_multiple(request: result, peer: peer)
        end.flatten
      end

      def handle_mix
        requests = RemoteFinder.new(pagination_params: pagination_params, post_type: post_type).requests
        handle_remote_requests(requests)
      end

      def handle_for_peer_id
        if peer_id == Current.peer.id
          posts = LocalFinder.new(pagination_params: pagination_params, post_type: post_type).posts
          handle_local_posts(posts)
        else
          requests = RemoteFinder.new(pagination_params: pagination_params, post_type: post_type, peer_id: peer_id).requests
          handle_remote_requests(requests)
        end
      end
  end
end
