# frozen_string_literal: true

module VirtualCommentsService
  class RemoveExternalComment
    class Error < StandardError; end
    attr_reader :cache_comment
    delegate :peer, to: :cache_comment

    def initialize(cache_comment)
      @cache_comment = cache_comment
    end

    def call!
      request.run

      return handle_valid_request if request.valid?

      raise Error, "unable to remove comment"
    end

    def handle_valid_request
      cache_comment.destroy
    end

    def request
      @request ||= HttpService::ApiClient.new(
        url: peer.api_url("/comments/#{cache_comment.remote_comment_id}"),
        method: :delete,
        peer: peer
      )
    end
  end
end
