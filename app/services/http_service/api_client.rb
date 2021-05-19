# frozen_string_literal: true

module HttpService
  class ApiClient
    attr_reader :request, :url, :method, :body
    def initialize(url:, method:, body: {}, record: nil, peer:)
      @request = klass.new(url, method, body, record, peer)
    end

    def run
      request.run
    end

    def klass
      Rails.env.test? ? HttpService::ApiTestHttpRequest : HttpService::ApiHttpRequest
    end
  end
end
