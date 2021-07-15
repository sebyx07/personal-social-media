# frozen_string_literal: true

module VirtualCommentsService
  class WhereFinder
    class FindLocal
      class Error < StandardError; end
      attr_reader :subject, :pagination_params, :parent_comment_id, :remote_post

      def initialize(pagination_params, subject, parent_comment_id, remote_post)
        @pagination_params = pagination_params
        @subject = subject
        @parent_comment_id = parent_comment_id
        @remote_post = remote_post
      end

      def results
        return @results if defined? @results
        pagination = PaginationService::Paginate.new(scope: scope, params: pagination_params, limit: WhereFinder::DEFAULT_LIMIT)
        @results = pagination.records
      end

      private
        def scope
          local_record.comments.unscoped
                      .order("comments.id": :desc)
                      .includes(:reaction_counters, :peer, :cache_reactions, :cache_comment)
                      .where(parent_comment_id: parent_comment_id)
        end

        def local_record
          if subject.subject_type == "RemotePost"
            remote_post.local_post
          end
        end
    end
  end
end
