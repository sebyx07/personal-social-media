# frozen_string_literal: true

module HttpService
  class ApiClientBatchTest
    attr_reader :status, :requests
    def initialize
      @status = :pending
      @requests = []
    end

    def queue(request)
      requests << request
    end

    def run
      raise ApiClientBatch::Error, "has already started" unless status == :pending
      @status = :running
      requests.each(&:run)
      @status = :done
    end
  end
end
