# frozen_string_literal: true

module VirtualCommentsService
  class UpdateComment
    attr_reader :cache_comment, :content, :comment_type

    def initialize(cache_comment, content, comment_type)
      @cache_comment = cache_comment
      @content = content
      @comment_type = comment_type
    end

    def call!
      return handle_locally if is_local_record?
      handle_remotely
    end

    private
      def is_local_record?
        cache_comment.peer_id == Current.peer.id
      end

      def handle_locally
        UpdateLocalComment.new(cache_comment, content, comment_type).call!
      end

      def handle_remotely
        UpdateExternalComment.new(cache_comment, content, comment_type).call!
      end
  end
end
