# frozen_string_literal: true

module VirtualCommentsService
  class CreateCommentExternally
    class Error < StandardError; end
    delegate :peer, to: :remote_record

    attr_reader :remote_record, :content, :parent_comment_id, :cache_comment, :comment_type
    def initialize(remote_record, content, parent_comment_id, comment_type)
      @remote_record = remote_record
      @content = content
      @parent_comment_id = parent_comment_id
      @comment_type = comment_type
    end

    def call!
      request.run

      return handle_valid_request if request.valid?

      raise Error, "unable to comment"
    end

    private
      def handle_valid_request
        cache_comment.remote_comment_id = request.json.dig(:comment, :id)

        cache_comment.tap(&:save!)
      end

      def cache_comment
        @cache_comment ||= CacheComment.new(
          subject_type: remote_record.class.name, subject_id: subject_id,
          content: content.saveable_content, comment_type: comment_type,
          peer: peer,
          remote_parent_comment_id: parent_comment_id
        )
      end

      def request
        @request ||= HttpService::ApiClient.new(
          url: peer.api_url("/comments"),
          method: :post,
          body: body,
          peer: peer
        )
      end

      def body
        {
          comment: {
            subject_id: subject_id,
            subject_type: subject_type,
            content: content.saveable_content,
            comment_type: comment_type,
            parent_comment_id: parent_comment_id
          }
        }
      end

      def subject_id
        if remote_record.is_a?(RemotePost)
          remote_record.remote_post_id
        end
      end

      def subject_type
        if remote_record.is_a?(RemotePost)
          "Post"
        end
      end
  end
end
