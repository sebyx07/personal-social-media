# frozen_string_literal: true

module HttpService
  class ApiClientBatchTyphoeusHydra
    class Error < StandardError; end
    attr_reader :status, :requests
    def initialize
      @status = :pending
      @requests = []
    end

    def queue(request)
      requests << request
    end

    def run
      raise Error, "has already started" unless status == :pending
      @status = :running
      requests.in_groups_of(250, false).each do |request_group|
        hydra = Typhoeus::Hydra.new

        request_group.each do |request|
          hydra.queue(request.request)
        end

        hydra.run
      end
      @status = :done
    end
  end
end
