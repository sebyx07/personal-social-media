# frozen_string_literal: true

module VirtualCommentsService
  class UpdateLocalComment
    attr_reader :cache_comment, :content, :comment_type

    def initialize(cache_comment, content, comment_type)
      @cache_comment = cache_comment
      @content = content
      @comment_type = comment_type
    end

    def call!
      return cache_comment unless needs_update?

      CacheComment.transaction do
        local_comment.update!(update_attributes)
        cache_comment.update!(update_attributes)
      end
      cache_comment
    end

    private
      def needs_update?
        cache_comment.content != content.saveable_content || cache_comment.comment_type != comment_type
      end

      def local_comment
        @local_comment ||= Comment.find_by(id: cache_comment.remote_comment_id)
      end

      def update_attributes
        {
          content: content.saveable_content[:content],
          comment_type: comment_type
        }
      end
  end
end
