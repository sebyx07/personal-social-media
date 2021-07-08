# frozen_string_literal: true

module PeersService
  class SetVerifyKeyOnWhoami
    attr_reader :verify_key, :current_peer
    def initialize(current_peer, verify_key_byte_array)
      @current_peer = current_peer
      if verify_key_byte_array.present?
        @verify_key = EncryptionService::EncryptedContentTransform.to_str(verify_key_byte_array)
      end
    end

    def call!
      return if verify_key.blank?

      current_peer.update!(verify_key: verify_key) if current_peer.verify_key.blank?
    end
  end
end
