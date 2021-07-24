# frozen_string_literal: true

module PeersService
  class RealTimePeerRecord
    attr_reader :peer
    def initialize(peer)
      @peer = peer
    end

    def can_propagate_realtime?
      true
    end

    def json
      return { id: peer.id } if peer.destroyed?
      PeerPresenter.new(peer).render_with_is_me
    end

    def virtual_id
      EncryptionService::EncryptedContentTransform.to_json(peer.public_key.to_s).join("-")
    end

    def type
      "Peer"
    end
  end
end
