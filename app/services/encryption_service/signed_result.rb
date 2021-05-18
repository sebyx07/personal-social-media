# frozen_string_literal: true

module EncryptionService
  class SignedResult
    attr_reader :message, :signature

    class << self
      def from_json(json)
        message = json["message"]
        signature = EncryptedContentTransform.to_str(json["signature"])
        new(message, signature)
      end
    end

    def initialize(message, signature)
      @message = message
      @signature = signature
    end

    def as_json(*_)
      {
        "message" => message,
        "signature" => EncryptedContentTransform.to_json(signature)
      }
    end
  end
end
