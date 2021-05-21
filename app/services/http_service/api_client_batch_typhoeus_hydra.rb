# frozen_string_literal: true

module HttpService
  class ApiClientBatchTyphoeusHydra
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
      requests.in_groups_of(ApiClientBatch::AR_BATCH_SIZE, false).each do |request_group|
        hydra = Typhoeus::Hydra.new

        request_group.each do |request|
          hydra.queue(request.request.request)
        end

        hydra.run

        request_group.each do |request|
          request.request.extract_response_after_request
        end
      end
      @status = :done
    end
  end
end
