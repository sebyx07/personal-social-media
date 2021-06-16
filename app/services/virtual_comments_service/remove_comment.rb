# frozen_string_literal: true

module VirtualCommentsService
  class RemoveComment
    attr_reader :cache_comment
    def initialize(cache_comment)
      @cache_comment = cache_comment
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
        RemoveLocalComment.new(cache_comment).call!
      end

      def handle_remotely
        RemoveExternalComment.new(cache_comment).call!
      end
  end
end
