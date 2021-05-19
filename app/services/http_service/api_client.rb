# frozen_string_literal: true

module HttpService
  class ApiClient
    attr_reader :request, :url, :method
    delegate :response, :record, :body, :url, :peer, to: :request
    delegate :status, :body_str, :valid?, :json, :safe_retry?, :raw_json, :schedule_retry, to: :response

    def initialize(url:, method:, body: {}, record: nil, peer:)
      @request = klass.new(url, method, body, record, peer)
    end

    def run
      request.run
      self
    end

    def klass
      Rails.env.test? ? HttpService::ApiTestHttpRequest : HttpService::ApiHttpTyphoeusRequest
    end
  end
end
