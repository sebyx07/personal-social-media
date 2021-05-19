# frozen_string_literal: true

module HttpService
  class ApiHttpRequest
    attr_accessor :record
    attr_reader :request, :peer, :url, :request_method, :body, :response

    def initialize(url, request_method, body, record, peer)
      @url = url
      @body = body
      @record = record
      @request_method = request_method.to_sym
      @peer = peer

      @request = Typhoeus::Request.new(
        url,
        method: @request_method,
        body: formatted_body,
        headers: headers
      )
    end

    def run
      request.run
      @response = ApiHttpResponse.new(request.response.response_code, request.response.body, peer, self)
      self
    end

    private
      def headers
        {
          "content-type": "application/json",
          "accept": "application/json"
        }
      end

      def is_get_method?
        return @is_get_method if defined? @is_get_method
        @is_get_method = %i(get delete).include?(request_method)
      end

      def formatted_body
        encrypted = __encrypt.encrypt(body.to_json)
        encrypted.as_json.merge!(
          domain_name: __encrypt.encrypt(profile.domain_name).as_json,
          public_key: EncryptionService::EncryptedContentTransform.to_json(profile.public_key.to_s)
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
