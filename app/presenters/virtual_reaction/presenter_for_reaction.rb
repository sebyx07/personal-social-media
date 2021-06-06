# frozen_string_literal: true

class VirtualReaction
  class PresenterForReaction
    def initialize(reaction)
      @reaction = reaction
    end

    delegate(*VirtualReaction::PERMITTED_DELEGATED_METHODS, to: :@reaction)
    delegate :id, :peer, to: :@post
  end
end
