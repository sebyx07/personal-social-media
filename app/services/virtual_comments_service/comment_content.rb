# frozen_string_literal: true

module VirtualCommentsService
  class CommentContent
    PERMITTED_CONTENT_ATTRIBUTES = [content: [:message]]

    attr_reader :permitted_params
    def initialize(params: nil, permitted_params: nil)
      @permitted_params = permitted_params || params.require(:comment).permit(*PERMITTED_CONTENT_ATTRIBUTES)
    end

    def saveable_content
      @saveable_content ||= permitted_params[:content].to_h
    end
  end
end
