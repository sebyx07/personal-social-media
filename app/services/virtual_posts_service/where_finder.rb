# frozen_string_literal: true

module VirtualPostsService
  class WhereFinder
    class Error < StandardError; end
    PRELOAD_ASSOCIATIONS_LOCALLY = [:remote_post, :reaction_counters, :cache_reactions, :comment_counter,
                                    latest_comments: [:peer, :reaction_counters, :cache_comment, :cache_reactions]]
    PRELOAD_ASSOCIATIONS_EXTERNALLY = [:peer, :cache_reactions]
    DEFAULT_LIMIT = 15

    attr_reader :pagination_params, :peer_id, :post_type, :show_from_feed_only
    def initialize(pagination_params, post_type: :standard, peer_id: nil, show_from_feed_only: false)
      @pagination_params = pagination_params
      @peer_id = peer_id
      @post_type = post_type
      @show_from_feed_only = show_from_feed_only
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
        request_helper_cache = RemoteRequestsCache.new

        requests.filter_map do |result|
          next VirtualPost.new(post: result, peer: Current.peer, remote_post: result.remote_post) if result.is_a?(Post)
          next unless result.valid?

          peer = result.peer
          request_helper_cache.requests << result
          next VirtualPost.load_multiple(request: result, peer: peer, request_helper_cache: request_helper_cache)
        end.flatten
      end

      def handle_mix
        requests = RemoteFinder.new(
          pagination_params: pagination_params,
          post_type: post_type, show_from_feed_only: show_from_feed_only
        ).requests
        handle_remote_requests(requests)
      end

      def handle_for_peer_id
        if peer_id.to_i == Current.peer.id
          posts = LocalFinder.new(pagination_params: pagination_params, post_type: post_type).posts
          handle_local_posts(posts)
        else
          requests = RemoteFinder.new(
            pagination_params: pagination_params, post_type: post_type,
            peer_id: peer_id, show_from_feed_only: show_from_feed_only
          ).requests
          handle_remote_requests(requests)
        end
      end
  end
end
