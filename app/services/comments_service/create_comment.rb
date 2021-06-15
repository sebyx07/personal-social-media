# frozen_string_literal: true

module CommentsService
  class CreateComment
    attr_reader :content, :current_peer

    def initialize(params, current_peer)
      @content = VirtualCommentsService::CommentContent.new(params)
      @current_peer = current_peer
    end

    def call!
    end

    def record
    end
  end
end
