# frozen_string_literal: true

module VirtualCommentsService
  class WhereFinder
    DEFAULT_LIMIT = 15
    attr_reader :pagination_params, :subject, :parent_comment_id
    def initialize(pagination_params, subject:, parent_comment_id:)
      @pagination_params = pagination_params
      @parent_comment_id = parent_comment_id
      @subject = subject
    end

    def results
      return handle_local if is_local_record?

      handle_remotely
    end

    private
      def handle_remotely
        json_records = VirtualCommentsService::WhereFinder::FindRemotely.new(pagination_params, subject, parent_comment_id).results
        json_records.map! do |json|
          VirtualComment.new(json: json)
        end
      end

      def handle_local
        comments = VirtualCommentsService::WhereFinder::FindLocal.new(pagination_params, subject, parent_comment_id).results
        comments.to_a.map! do |comment|
          VirtualComment.new(comment: comment)
        end
      end

      def is_local_record?
        subject.peer_id == Current.peer.id
      end
  end
end
