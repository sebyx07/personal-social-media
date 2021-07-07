# frozen_string_literal: true

module EncryptionService
  class Sign
    def sign_message(message)
      SignedResult.new(message, signature.sign(message), signature.verify_key.to_s)
    end

    if Rails.env.test?
      def _test_sign_message(message, signing_key)
        SignedResult.new(message, signing_key.sign(message), signing_key.verify_key.to_s)
      end
    end

    private
      def signature
        @signature ||= Current.profile.signing_key
      end
  end
end
