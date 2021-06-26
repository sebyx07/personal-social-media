# frozen_string_literal: true

module VirtualReactionsService
  class WhereFinder
    class FindLocal
      class Error < StandardError; end
      attr_reader :cache_record, :pagination_params

      def initialize(pagination_params, cache_record)
        @pagination_params = pagination_params
        @cache_record = cache_record
      end

      def results
        return @results if defined? @results
        scope = local_record.reactions.unscoped.includes(:peer, :reaction_counter).order(id: :desc)
        pagination = PaginationService::Paginate.new(scope: scope, params: pagination_params, limit: WhereFinder::DEFAULT_LIMIT)
        @results = pagination.records
      end

      def local_record
        return @local_record if defined? @local_record
        if cache_record.is_a?(RemotePost)
          @local_record = cache_record.local_post
        end
        raise Error, "no local error #{cache_record}" if @local_record.blank?

        @local_record
      end
    end
  end
end
