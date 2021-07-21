# frozen_string_literal: true

class VirtualPost
  class PresenterForPost
    def initialize(post, peer)
      @post = post
      @peer = peer
    end

    delegate(*VirtualPost::PERMITTED_DELEGATED_METHODS, to: :@post)
    delegate :reaction_counters, :cache_reactions, :latest_comments, :cache_comments, :is_valid_signature?, :content_with_attachments, to: :@post

    def request_helper_cache
    end
  end
end
