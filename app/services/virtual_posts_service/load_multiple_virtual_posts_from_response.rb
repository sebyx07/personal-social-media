# frozen_string_literal: true

module VirtualPostsService
  class LoadMultipleVirtualPostsFromResponse
    attr_reader :peer, :request, :request_helper_cache
    def initialize(peer, request, request_helper_cache)
      @peer = peer
      @request = request
      @request_helper_cache = request_helper_cache
    end

    def call
      request.json[:posts].map do |post_json|
        fake_request = VirtualPostsService::FakeJsonRequest.new(post_json, peer)
        remote_post = get_remote_post(post_json)
        fake_request.record = remote_post
        VirtualPost.new(request: fake_request, peer: peer, remote_post: remote_post, request_helper_cache: request_helper_cache)
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
