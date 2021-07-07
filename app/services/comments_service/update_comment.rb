# frozen_string_literal: true

module CommentsService
  class UpdateComment
    class Error < StandardError; end
    attr_reader :content, :comment, :comment_params

    def initialize(comment_params, comment)
      @comment_params = comment_params
      @content = VirtualCommentsService::CommentContent.new(permitted_params: comment_params)
      @comment = comment
    end

    def call!
      comment.tap do |c|
        c.update!(content: content.saveable_content, signature: signature)
      end
    end

    private
      def signature
        EncryptionService::EncryptedContentTransform.to_str(comment_params[:signature])
      end
  end
end
