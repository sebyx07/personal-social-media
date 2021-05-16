# frozen_string_literal: true

module PeersService
  class ControllerFindCurrent
    attr_reader :public_key, :encrypted_domain_name

    def initialize(pubic_key_byte_array, encrypted_domain_name)
      @public_key = EncryptionService::EncryptedContentTransform.to_str(pubic_key_byte_array)
      @encrypted_domain_name = encrypted_domain_name
    end

    def call!
      return nil if peer.unfriendly?
      peer.domain_name = domain_name
      peer.save!
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
  end
end
