# frozen_string_literal: true

module HttpService
  class ApiClient
    attr_reader :request, :url, :method, :body, :response
    def initialize(url:, method:, body: nil, record: nil, peer:)
      @request = HttpService::ApiHttpRequest.new(url, method, body, record, peer)
    end

    def run
      request.run
    end
  end
end
