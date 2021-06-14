# frozen_string_literal: true

class VirtualPost
  class LoadMultipleError < StandardError; end
  PERMITTED_DELEGATED_METHODS = %i(created_at updated_at content)

  attr_reader :post, :request, :peer

  class << self
    def load_multiple(peer:, request:)
      return new(request: request, peer: peer, remote_post: request.record) if request.json[:post].present?
      raise LoadMultipleError, "No posts" if request.json[:posts].blank?

      VirtualPostsService::LoadMultipleVirtualPostsFromResponse.new(peer, request).call
    end
  end

  def initialize(post: nil, request: nil, peer:, remote_post:)
    @remote_post = remote_post
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
  delegate :reaction_counters, :cache_reactions, to: :@presenter
  delegate :id, to: :@remote_post

  class << self
    def where(pagination_params: nil, post_type:, peer_id: nil, show_from_feed_only: false)
      results = VirtualPostsService::WhereFinder.new(
        pagination_params, post_type: post_type,
        peer_id: peer_id, show_from_feed_only: show_from_feed_only
      ).results

      sorted_results = results.sort_by(&:id)
      sorted_results.reverse
    end
  end
end
