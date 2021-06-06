# frozen_string_literal: true

module VirtualPostsService
  class FakeJsonRequest
    attr_reader :peer
    attr_accessor :record

    def initialize(post_json, peer)
      @post_json = post_json
      @peer = peer
    end

    def json
      @json ||= {
        post: @post_json
      }
    end

    def valid?
      true
    end
  end
end
