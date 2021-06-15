# frozen_string_literal: true

module VirtualCommentsService
  class CommentContent
    attr_reader :params
    def initialize(params)
      @params = params.require(:comment).permit(:comment_type, content: [:message])
    end

    def comment_type
      params[:comment_type]
    end

    def saveable_content
      params[:content]
    end
  end
end
