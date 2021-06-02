# frozen_string_literal: true

class VirtualPost
  class PresenterForPost
    def initialize(post, peer)
      @post = post
      @peer = peer
    end

    delegate(*VirtualPost::PERMITTED_DELEGATED_METHODS, to: :@post)
  end
end
