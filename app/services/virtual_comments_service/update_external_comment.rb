# frozen_string_literal: true

module VirtualCommentsService
  class UpdateExternalComment
    delegate :peer, to: :cache_comment
    attr_reader :cache_comment, :content, :comment_type

    def initialize(cache_comment, content, comment_type)
      @cache_comment = cache_comment
      @content = content
      @comment_type = comment_type
    end

    def call!
      request.run

      return handle_valid_request if request.valid?

      raise Error, "unable to comment"
    end

    private
      def handle_valid_request
        cache_comment.tap do |c|
          c.update!(update_attributes)
        end
      end

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

      def request
        @request ||= HttpService::ApiClient.new(
          url: peer.api_url("/comments/#{cache_comment.remote_comment_id}"),
          method: :patch,
          body: body,
          peer: peer
        )
      end

      def body
        {
          comment: update_attributes
        }
      end
  end
end
