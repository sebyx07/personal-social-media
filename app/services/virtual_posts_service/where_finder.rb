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
