# frozen_string_literal: true

module CommentsService
  class GetCacheCommentIdFromCache
    attr_reader :cache, :parent_record, :peer, :comment
    def initialize(cache, parent_record, comment)
      @cache = cache
      @parent_record = parent_record
      @peer = parent_record.peer
      @comment = comment
    end

    def call
      return handle_local_comment if comment.is_a?(Comment)
      handle_remote_comment
    end

    def handle_local_comment
      @comment.cache_comment&.id
    end

    def handle_remote_comment
      @cache.cache_comments.detect do |cache_comment|
        cache_comment.peer == peer && cache_comment.remote_comment_id == comment_id
      end&.id
    end
  end
end
