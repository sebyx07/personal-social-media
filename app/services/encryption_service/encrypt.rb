# frozen_string_literal: true

module EncryptionService
  class Encrypt
    attr_reader :external_public_key

    def initialize(external_public_key)
      @external_public_key = external_public_key
    end

    def encrypt(message)
      nonce = create_new_nonce
      EncryptedResult.new(build_ciphertext(nonce, message), nonce)
    end

    private
      def build_ciphertext(nonce, content)
        box.encrypt(nonce, content)
      end

      def box
        @box ||= RbNaCl::Box.new(external_public_key, my_private_key)
      end

      def create_new_nonce
        RbNaCl::Random.random_bytes(box.nonce_bytes)
      end

      def my_private_key
        @my_private_key ||= Current.profile.private_key
      end
  end
end
