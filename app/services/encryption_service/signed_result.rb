# frozen_string_literal: true

module EncryptionService
  class SignedResult
    attr_reader :message, :signature, :verify_key

    class << self
      def from_json(json)
        message = json["message"]
        signature = EncryptedContentTransform.to_str(json["signature"])
        new(message, signature, json["verify_key"])
      end
    end

    def initialize(message, signature, verify_key)
      @message = message
      @signature = signature
      @verify_key = verify_key
    end

    def as_json(*_)
      {
        "message" => message,
        "signature" => EncryptedContentTransform.to_json(signature),
        "verify_key" => EncryptedContentTransform.to_json(verify_key)
      }
    end
  end
end
