# frozen_string_literal: true

module PeersService
  class RemoteFakePeerValidator
    delegate_missing_to :json_peer
    attr_reader :local_peer, :json_peer

    def initialize(local_peer, json_peer)
      @local_peer = local_peer
      @json_peer = json_peer
    end

    def status
      return [] if local_peer.blank?
      return %i(fake) if tempered?

      local_peer.status
    end

    def tempered?
    end
  end
end
