# frozen_string_literal: true

class VirtualPost
  class LoadMultipleError < StandardError; end
  PERMITTED_DELEGATED_METHODS = %i(id created_at updated_at content)

  attr_reader :post, :request, :peer

  class << self
    def load_multiple(peer:, request:)
      return new(request: request, peer: peer) if request.json[:post].present?
      raise LoadMultipleError, "No posts" if request.json[:posts].blank?

      request.json[:posts].map do |post_json|
        fake_request = VirtualPostsService::FakeRequest.new(post_json)

        new(request: fake_request, peer: peer)
      end
    end
  end

  def initialize(post: nil, request: nil, peer:)
    @peer = peer
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
