# frozen_string_literal: true

module EncryptionService
  class EncryptedContentTransform
    class Error < StandardError; end

    class << self
      def to_json(raw_string)
        raise Error, "no raw_string supplied" if raw_string.nil?
        raw_string.bytes
      end

      def to_str(bytes)
        raise Error, "no raw_string supplied" if bytes.nil?
        bytes.pack("c*")
      end
    end
  end
end
