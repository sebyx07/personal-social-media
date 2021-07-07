# frozen_string_literal: true

module VirtualCommentsService
  class UpdateLocalComment
    attr_reader :cache_comment, :content, :comment_type
    delegate :local_comment, to: :cache_comment

    def initialize(cache_comment, content, comment_type)
      @cache_comment = cache_comment
      @content = content
      @comment_type = comment_type
    end

    def call!
      return cache_comment unless needs_update?
      CacheComment.transaction do
        cache_comment.update!(update_attributes)
        local_comment.update!(update_attributes.merge(signature: signature))
      end
      cache_comment
    end

    private
      def needs_update?
        cache_comment.content != content.saveable_content || cache_comment.comment_type != comment_type
      end

      def update_attributes
        {
          content: content.saveable_content,
          comment_type: comment_type,
        }
      end

      def signature
        CommentsService::JsonSignature.new(cache_comment).call_raw_str
      end
  end
end
