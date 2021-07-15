# frozen_string_literal: true

module CommentsService
  class GetCacheCommentIdFromCache
    attr_reader :cache, :parent_record, :comment
    def initialize(cache, parent_record, comment)
      @cache = cache
      @parent_record = parent_record
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
        if peer.present?
          cache_comment.peer == peer && cache_comment.remote_comment_id == comment.id
        else
          cache_comment.remote_comment_id == comment.id
        end
      end
    end

    def peer
      return @peer if defined? @peer
      @peer = @parent_record&.peer
    end
  end
end
