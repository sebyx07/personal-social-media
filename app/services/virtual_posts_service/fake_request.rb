# frozen_string_literal: true

module VirtualPostsService
  class FakeRequest
    def initialize(post_json)
      @post_json = post_json
    end

    def json
      @json ||= {
        post: @post_json
      }
    end
  end
end
