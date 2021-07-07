# frozen_string_literal: true

module PeersService
  class EqualPeer
    class Error < StandardError; end
    attr_reader :peer, :compared_peer
    def initialize(peer, compared_peer)
      @peer = peer
      @compared_peer = compared_peer
    end

    def call
      if peer.is_a?(Peer) && compared_peer.is_a?(Peer)
        return peer.public_key == compared_peer.public_key
      end
      get_key_for_peer(peer) == get_key_for_peer(compared_peer)
    end

    def get_key_for_peer(peer)
      if peer.is_a?(Peer)
        return peer.public_key_serialized
      elsif peer.is_a?(PeersService::FakePeerRemote)
        return peer.public_key
      end

      raise Error, "Invalid peer type: #{peer.inspect}"
    end
  end
end
