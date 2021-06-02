# frozen_string_literal: true

class VirtualPost
  PERMITTED_DELEGATED_METHODS = %i(created_at)

  attr_reader :post, :request
  def initialize(post: nil, request: nil, peer:)
    if post.present?
      @post = post
      @presenter = VirtualPost::PresenterForPost.new(post, peer)
    elsif request.present?
      @request = request
      @presenter = VirtualPost::PresenterForRequest.new(request, peer)
    end
  end

  delegate(*PERMITTED_DELEGATED_METHODS, to: :@presenter)

  class << self
    def where(pagination_params: nil, post_type:, peer_id: nil)
      VirtualPostsService::WhereFinder.new(pagination_params, post_type: post_type, peer_id: peer_id).results
    end
  end
end
