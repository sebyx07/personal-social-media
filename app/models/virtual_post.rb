# frozen_string_literal: true

class VirtualPost
  attr_reader :post, :request, :peer
  def initialize(post: nil, request: nil, peer:)
    @post = post
    @request = request
    @peer = peer
  end

  class << self
    def where(pagination_params: nil, peer_id: nil)
      VirtualPostsService::WhereFinder.new(pagination_params, peer_id).results
    end
  end
end
