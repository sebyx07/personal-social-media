# frozen_string_literal: true

module VirtualCommentsService
  class RemoveLocalComment
    attr_reader :cache_comment
    delegate :local_comment, to: :cache_comment

    def initialize(cache_comment)
      @cache_comment = cache_comment
    end

    def call!
      CacheComment.transaction do
        cache_comment.destroy
        local_comment.destroy
      end
    end
  end
end
