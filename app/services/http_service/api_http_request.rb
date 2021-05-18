# frozen_string_literal: true

module HttpService
  class ApiHttpRequest
    attr_accessor :record
    attr_reader :request, :peer

    def initialize(url, request_method, body, record, peer)
      @body = body
      @record = record
      @request_method = request_method.to_sym
      @peer = peer

      @request = Typhoeus::Request.new(
        url,
        method: @request_method,
        body: formatted_body,
        headers: is_get_method? ? get_headers : post_headers
      )
    end

    def run
      request.run
      self
    end

    private
      def get_headers
        {
          "accept": "application/json"
        }
      end

      def post_headers
        get_headers.merge(
          "content-type": "application/json"
        )
      end

      def is_get_method?
        return @is_get_method if defined? @is_get_method
        @is_get_method = %i(get delete).include?(request_method)
      end

      def formatted_body
        return nil if is_get_method?

        encrypted = __encrypt.encrypt(body.to_json)
        encrypted.as_json.merge!(
          domain_name: __encrypt.encrypt(profile.domain_name).as_json,
          public_key: EncryptionService::EncryptedContentTransform.to_json(profile.public_key)
        ).to_json
      end

      def __encrypt
        @__encrypt ||= EncryptionService::Encrypt.new(peer.public_key)
      end

      def profile
        Current.profile
      end
  end
end
