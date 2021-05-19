# frozen_string_literal: true

module HttpService
  class ApiHttpResponse
    attr_reader :status, :peer, :body_str, :request
    def initialize(status, body_str, peer, request)
      @status = status
      @body_str = body_str
      @peer = peer
      @request = request
    end

    def valid?
      return @is_valid if defined? @is_valid
      if status > 400 || status.blank?
        mark_for_retry
        return @is_valid = false
      end

      unless encrypted_result.valid?
        mark_for_retry
        return @is_valid = false
      end

      @is_valid = @body_str.present? && decrypted_result.present?
    rescue RbNaCl::CryptoError
      peer.mark_as_fake!
      @is_valid = false
    rescue JSON::ParseError
      mark_for_retry
      @is_valid = false
    end

    def json
      @json ||= JSON.parse!(decrypted_result).with_indifferent_access
    end

    def safe_retry?
      @safe_retry
    end

    def raw_json
      @raw_json ||= JSON.parse!(@body_str)
    end

    def schedule_retry
    end

    private
      def encrypted_result
        return @encrypted_result if defined? @encrypted_result
        @encrypted_result = EncryptionService::EncryptedResult.from_json(raw_json)
      end

      def decrypted_result
        @decrypted_result ||= EncryptionService::Decrypt.new(peer.public_key).decrypt(encrypted_result)
      end

      def mark_for_retry
        @safe_retry = true
      end
  end
end
