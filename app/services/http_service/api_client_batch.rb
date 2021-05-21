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

    def runner_klass
      Rails.env.test? ? ApiClientBatchTest : ApiClientBatchTyphoeusHydra
    end
  end
end
