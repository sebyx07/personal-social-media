# frozen_string_literal: true

module HttpService
  class TemplateApiRequest
    attr_reader :url, :body, :method

    def initialize(url:, method:, body: {})
      @url = "/api" + url
      @method = method
      @body = body
    end
  end
end
