# frozen_string_literal: true

module HttpService
  class ApiClient
    class InvalidResponse < StandardError; end
    MAX_RETRIES = 5
    attr_reader :request, :url, :method
    delegate :response, :record, :record=, :body, :url, :peer, to: :request
    delegate :status, :body_str, :json, :safe_retry?, :raw_json, :schedule_retry, to: :response

    def initialize(url:, method:, body: {}, record: nil, peer:)
      @request = klass.new(url, method, body, record, peer)
    end

    def run
      request.run
      self
    end

    def run_with_retry_in_background(max_retries: MAX_RETRIES)
      RetryRequest.create!(
        payload: body, url: url, peer_ids: [peer.id],
        request_method: method, max_retries: max_retries,
        request_type: :single
      )
    end

    def valid?
      return @valid if defined? @valid
      @valid = response.valid?
      return @valid if Rails.env.production? && !DeveloperService::IsEnabled.is_enabled?
      @valid.tap do |v|
        handle_test_invalid_request unless v
      end
    end

    def handle_test_invalid_request
      # binding.pry # uncomment this to debug
      error_msg = { url: url, status: status, body_str: body_str }.to_json
      DeveloperService::HandleError.handle_error(InvalidResponse.new(error_msg))
    end

    private
      def klass
        Rails.env.test? ? HttpService::ApiTestHttpRequest : HttpService::ApiHttpTyphoeusRequest
      end
  end
end
