# frozen_string_literal: true

module PeersService
  class RemotePeerWithFriendship
    delegate_missing_to :@best_peer
    attr_reader :best_peer, :local_peer

    class << self
      def get_from_cache(cache, json_peer)
        return json_peer if cache.blank?

        local_peer = cache.sub_peers.detect do |peer|
          peer == json_peer
        end

        new(local_peer, json_peer)
      end
    end

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
