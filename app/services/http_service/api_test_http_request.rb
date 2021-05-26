# frozen_string_literal: true

module HttpService
  class ApiTestHttpRequest
    attr_accessor :record
    attr_reader :real_request, :ctx, :response, :peer

    delegate_missing_to :@real_request

    def initialize(url, request_method, body, record, peer)
      @peer = peer
      @record = record
      @real_request = ApiHttpTyphoeusRequest.new(url, request_method, body, record, peer)
      @ctx = TwoPeopleHelper.test_ctx
    end

    def run
      before_take_over_body = formatted_body
      TwoPeopleHelper.take_over_wrap! do
        ctx.send(request_method, url, params: before_take_over_body, headers: headers)
        @response = ApiHttpResponse.new(ctx.response.status, ctx.response.body, peer, self)
      end
      self
    end

    private
      def headers
        real_request.send(:headers)
      end

      def formatted_body
        real_request.send(:formatted_body)
      end
  end
end
