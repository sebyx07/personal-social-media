# frozen_string_literal: true

module VirtualPostsService
  class FakeJsonRequest
    attr_reader :peer

    def initialize(post_json, peer)
      @post_json = post_json
      @peer = peer
    end

    def json
      @json ||= {
        post: @post_json
      }
    end
  end
end
