# frozen_string_literal: true

module HttpService
  class ApiClientBatch
    class Error < StandardError; end
    AR_BATCH_SIZE = 250
    attr_reader :runner, :requests
    def initialize(requests:)
      @requests = requests
      @runner = runner_klass.new
    end

    def run
      requests.each do |r|
        runner.queue(r)
      end

      runner.run
    end

    class << self
      def run_with_retry_in_background(template_request:, peer_ids: [], all: false, max_retries: ApiClient::MAX_RETRIES)
        select_peer_ids = all ? ["all"] : peer_ids

        RetryRequest.create!(
          payload: template_request.body, url: template_request.url, peer_ids: select_peer_ids,
          request_method: template_request.method, max_retries: max_retries,
          request_type: :multiple
        )
      end
    end

    def runner_klass
      Rails.env.test? ? ApiClientBatchTest : ApiClientBatchTyphoeusHydra
    end
  end
end
