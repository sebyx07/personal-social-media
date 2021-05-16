# frozen_string_literal: true

module EncryptionService
  class EncryptedResult
    attr_reader :cypher_text, :nonce

    class << self
      def from_json(json)
        cypher_text = EncryptedContentTransform.to_str(json["cypher_text"])
        nonce = EncryptedContentTransform.to_str(json["nonce"])
        new(cypher_text, nonce)
      end
    end

    def initialize(cypher_text, nonce)
      @cypher_text = cypher_text
      @nonce = nonce
    end

    def as_json
      {
        "cypher_text" => EncryptedContentTransform.to_json(cypher_text),
        "nonce" => EncryptedContentTransform.to_json(nonce)
      }
    end
  end
end
