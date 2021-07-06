# frozen_string_literal: true

module VirtualCommentsService
  class WhereFinder
    class FindLocal
      class Error < StandardError; end
      attr_reader :subject, :pagination_params, :parent_comment_id

      def initialize(pagination_params, subject, parent_comment_id)
        @pagination_params = pagination_params
        @subject = subject
        @parent_comment_id = parent_comment_id
      end

      def results
        return @results if defined? @results
        pagination = PaginationService::Paginate.new(scope: scope, params: pagination_params, limit: WhereFinder::DEFAULT_LIMIT)
        @results = pagination.records
      end

      private
        def scope
          local_record.comments.unscoped
                      .includes(:reaction_counters, :peer)
                      .where(parent_comment_id: parent_comment_id)
        end

        def local_record
          if subject.is_a?(RemotePost)
            subject.local_post
          end
        end
    end
  end
end
