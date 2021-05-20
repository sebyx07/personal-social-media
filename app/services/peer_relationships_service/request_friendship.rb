# frozen_string_literal: true

module PeerRelationshipsService
  class RequestFriendship
    def initialize(peer)
      @peer = peer
    end

    def call!
    end

    def can_make_transition?
    end
  end
end
