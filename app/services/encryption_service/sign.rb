# frozen_string_literal: true

module EncryptionService
  class Sign
    def sign_message(message)
      SignedResult.new(message, signature.sign(message))
    end

    private
      def signature
        @signature ||= Current.profile.signing_key
      end
  end
end
