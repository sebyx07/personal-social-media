# frozen_string_literal: true

module VirtualPostsService
  class LocalFinder
    attr_reader :pagination_params, :post_ids, :post_type
    def initialize(pagination_params: nil, post_ids: nil, post_type:)
      @pagination_params = pagination_params
      @post_ids = post_ids
      @post_type = post_type
    end

    def posts
      return @posts if defined? @posts
      @posts = PaginationService::Paginate.new(scope: default_scope, params: pagination_params, limit: WhereFinder::DEFAULT_LIMIT).records
    end

    private
      def default_scope
        return @query if defined? @query

        @query = Post.includes(PRELOAD_ASSOCIATIONS_LOCALLY).where(post_type: post_type).order(id: :desc)
        if post_ids.present?
          @query = query.where(post_ids: post_ids)
        end

        @query
      end
  end
end
