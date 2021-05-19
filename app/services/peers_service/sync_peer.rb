# frozen_string_literal: true

module PeersService
  class SyncPeer
    attr_reader :peer, :params
    def initialize(peer, params)
      @peer = peer
      @params = params
    end

    def call!
      peer.update!(params)
    end
  end
end
