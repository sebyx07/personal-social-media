# frozen_string_literal: true

module RetryRequestsService
  class RetryRequestResult
    attr_reader :request, :requests
    attr_accessor :valid, :failed_peer_ids

    def initialize(request: nil, requests: [])
      @requests = request.present? ? [request] : requests
    end

    def valid?
      return @valid if defined? @valid
      invalid_requests.blank?
    end

    def failed_peer_ids
      @failed_peer_ids ||= invalid_requests.map do |req|
        req.peer.id
      end
    end

    private
      def invalid_requests
        @invalid_requests ||= requests.select { |r| !r.valid? && r.safe_retry? }
      end
  end
end
