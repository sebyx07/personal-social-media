# frozen_string_literal: true

module VirtualPostsService
  class RemoteFinderRequest
    attr_reader :remote_post
    attr_accessor :local_post

    def initialize(remote_post)
      @remote_post = remote_post
    end

    def valid?
      return true if local_post.present?
      api_client_request.valid?
    end

    def is_remote_peer?
      return @is_remote_peer if defined? @is_remote_peer
      @is_remote_peer = remote_post.peer_id != Current.peer.id
    end

    def api_client_request
      return @api_client_request if defined? @api_client_request
      @api_client_request = HttpService::ApiClient.new(
        url: remote_post.peer.api_url("/posts/#{remote_post.remote_post_id}"),
        method: :post,
        record: self,
        peer: remote_post.peer
      )
    end
  end
end
