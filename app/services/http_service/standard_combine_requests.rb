# frozen_string_literal: true

module HttpService
  class StandardCombineRequests
    attr_reader :requests, :optimized_url
    def initialize(requests, optimized_url)
      @requests = requests
      @optimized_url = optimized_url
    end

    def call
      grouped_by_requests = requests.group_by(&:peer)
      grouped_by_requests.map do |peer, group|
        next group if group.size == 1

        group.first.tap do |first_request|
          first_request.url = peer.api_url(optimized_url)
          first_request.optimized_merge_body(ids: group.map(&:optimized_record_id))
          group.each do |req|
            req.combined_request = first_request
          end
        end
      end.flatten
    end
  end
end
