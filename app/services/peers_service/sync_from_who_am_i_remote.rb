# frozen_string_literal: true

module PeersService
  class SyncFromWhoAmIRemote
    attr_reader :peer, :request, :json, :will_retry, :response
    def initialize(peer, will_retry:)
      @peer = peer
      @will_retry = will_retry
      @request = HttpService::ApiClient.new(url: peer.api_url("/instance/whoami"), method: :post, peer: peer)
    end

    def call!
      request.run
      return self unless request.valid?
      @json = request.json[:profile]
      return self unless compare

      add_peer_attributes
      self
    end

    private
      def compare
        peer.public_key == response_public_key && peer.verify_key == response_verify_key
      end

      def response_public_key
        EncryptionService::EncryptedContentTransform.to_str(json[:public_key])
      end

      def response_verify_key
        EncryptionService::EncryptedContentTransform.to_str(json[:verify_key])
      end

      def add_peer_attributes
        peer.assign_attributes(
          name: json[:name],
          email_hexdigest: json[:email_hexdigest],
          nickname: json[:nickname],
        )
      end
  end
end
