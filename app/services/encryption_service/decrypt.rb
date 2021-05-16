# frozen_string_literal: true

module EncryptionService
  class Decrypt
    attr_reader :external_public_key

    def initialize(external_public_key)
      @external_public_key = external_public_key
    end

    def decrypt(encrypted_result)
      box.decrypt(encrypted_result.nonce, encrypted_result.cypher_text)
    end

    private
      def box
        @box ||= RbNaCl::Box.new(external_public_key, my_private_key)
      end

      def my_private_key
        @my_private_key ||= Current.profile.private_key
      end
  end
end
