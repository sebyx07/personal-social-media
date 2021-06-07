# frozen_string_literal: true

module VirtualPostsService
  class RemoteFinder
    attr_reader :pagination_params, :peer_id, :post_type, :show_from_feed_only
    def initialize(pagination_params: nil, post_type:, peer_id: nil, show_from_feed_only:)
      @pagination_params = pagination_params
      @post_type = post_type
      @peer_id = peer_id
      @show_from_feed_only = show_from_feed_only
    end

    def requests
      return from_local_remote_posts if peer_id.blank?

      from_peer
    end

    private
      def from_local_remote_posts
        resolver = VirtualPostsService::RemoteFinderResolver.new(remote_posts)
        resolver.run!

        resolver.resolve_all
      end

      def from_peer
        [
          FromPeer.new(pagination_params, post_type, peer_id).result
        ]
      end

      def remote_posts
        return @remote_posts if defined? @remote_posts
        @remote_posts = PaginationService::Paginate.new(scope: default_scope, params: pagination_params, limit: WhereFinder::DEFAULT_LIMIT).records
        @remote_posts = @remote_posts.select do |rpost|
          rpost.peer.friendly? || rpost.peer.is_me?
        end
      end

      def default_scope
        return @query if defined? @query

        @query = RemotePost.where(post_type: post_type).includes(WhereFinder::PRELOAD_ASSOCIATIONS_EXTERNALLY)

        if show_from_feed_only
          @query = @query.where(show_in_feed: true)
        end
      end
  end
end
