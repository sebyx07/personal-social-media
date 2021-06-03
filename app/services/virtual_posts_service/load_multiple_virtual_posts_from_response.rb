# frozen_string_literal: true

module VirtualPostsService
  class LoadMultipleVirtualPostsFromResponse
    attr_reader :peer, :request
    def initialize(peer, request)
      @peer = peer
      @request = request
    end

    def call
      request.json[:posts].map do |post_json|
        fake_request = VirtualPostsService::FakeJsonRequest.new(post_json, peer)

        VirtualPost.new(request: fake_request, peer: peer, remote_post: get_remote_post(post_json))
      end
    end

    def get_remote_post(post_json)
      id = post_json[:id]

      request.record.detect do |remote_post|
        remote_post.remote_post_id == id
      end
    end
  end
end
