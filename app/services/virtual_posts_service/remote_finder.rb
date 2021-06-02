# frozen_string_literal: true

module VirtualPostsService
  class RemoteFinder
    attr_reader :pagination_params, :peer_id
    def initialize(pagination_params: nil, peer_id: nil)
      @pagination_params = pagination_params
      @peer_id = peer_id
    end

    def requests
      resolver = VirtualPostsService::RemoteFinderResolver.new(remote_posts)
      resolver.run!

      resolver.resolve_all
    end

    private
      def remote_posts
        return @remote_posts if defined? @remote_posts
        @remote_posts = PaginationService::Paginate.new(scope: default_scope, params: pagination_params, limit: WhereFinder::DEFAULT_LIMIT).records
        @remote_posts = @remote_posts.select do |rpost|
          rpost.peer.friendly?
        end
      end

      def default_scope
        return @query if defined? @query

        @query = RemotePost.includes(:peer).order(id: :desc)
        if peer_id.present?
          @query = @query.where(peer_id: peer_id)
        end

        @query
      end
  end
end
