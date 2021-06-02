# frozen_string_literal: true

module PeersService
  class ControllerFindCurrent
    attr_reader :public_key, :encrypted_domain_name

    def initialize(public_key_byte_array, encrypted_domain_name)
      @public_key = EncryptionService::EncryptedContentTransform.to_str(public_key_byte_array)
      @encrypted_domain_name = encrypted_domain_name
    end

    def call!
      return nil if peer.unfriendly?
      any_peer_call!
    end

    def any_peer_call!
      peer.tap do |p|
        p.domain_name = domain_name
        p.status = [:stranger] unless p.persisted?
        update_server_last_seen_at
        p.save!
      end
    rescue RbNaCl::CryptoError
      peer.mark_as_fake!
      nil
    end

    private
      def peer
        @peer ||= Peer.find_or_initialize_by(public_key: public_key)
      end

      def decrypt
        @decrypt ||= EncryptionService::Decrypt.new(peer.public_key)
      end

      def domain_name
        encrypted_result = EncryptionService::EncryptedResult.from_json(encrypted_domain_name)
        decrypt.decrypt(encrypted_result)
      end

      def update_server_last_seen_at
        current = peer.server_last_seen_at
        if current.blank? || current < 15.minutes.ago
          peer.server_last_seen_at = Time.zone.now
        end
      end
  end
end
