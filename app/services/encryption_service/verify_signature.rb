# frozen_string_literal: true

module EncryptionService
  class VerifySignature
    attr_reader :verify_key
    def initialize(verify_key)
      @verify_key = RbNaCl::VerifyKey.new(verify_key)
    end

    def verify(signed_result)
      verify_key.verify(signed_result.signature, signed_result.message)
    rescue RbNaCl::BadSignatureError
      false
    end
  end
end
