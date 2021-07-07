# frozen_string_literal: true

module PeersService
  class RemotePeerWithFriendship
    delegate_missing_to :@best_peer
    attr_reader :best_peer, :local_peer

    def initialize(local_peer, json_peer)
      @local_peer = local_peer
      @best_peer = local_peer || json_peer
    end

    def status
      return [] if local_peer.blank?

      local_peer.status
    end
  end
end
