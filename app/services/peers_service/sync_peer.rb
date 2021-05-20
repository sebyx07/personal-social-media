# frozen_string_literal: true

module PeersService
  class SyncPeer
    class Error < StandardError; end
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
