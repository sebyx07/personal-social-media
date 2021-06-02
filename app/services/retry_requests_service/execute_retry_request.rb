# frozen_string_literal: true

module RetryRequestsService
  class ExecuteRetryRequest
    attr_reader :retry_request, :request, :current_requests
    delegate :limited_peers, :url, :request_method, :payload, to: :retry_request

    def initialize(retry_request)
      @retry_request = retry_request
    end

    def call!
      return if limited_peers.blank?
      return handle_single(limited_peers.first) if limited_peers.size == 1
      handle_multiple
    end

    private
      def handle_single(peer)
        @request = build_request(peer)
        request.run
        RetryRequestsService::RetryRequestResult.new(request: request)
      end

      def handle_multiple
        retry_request.batched_peers do |peers|
          @current_requests = peers.map do |peer|
            build_request(peer)
          end

          run_requests
          collect_result
        end
        assign_peer_ids
        multiple_result
      end

      def build_request(peer)
        HttpService::ApiClient.new(url: peer.api_url(url), method: request_method, peer: peer, body: payload)
      end

      def run_requests
        client_batch = HttpService::ApiClientBatch.new(requests: current_requests)
        client_batch.run
      end

      def collect_result
        collect_valid
        collect_peer_ids
      end

      def multiple_result
        return @multiple_result if defined? @multiple_result
        @multiple_result = RetryRequestsService::RetryRequestResult.new.tap do |result|
          result.valid = true
        end
      end

      def collect_valid
        return unless multiple_result.valid?
        current_requests.each do |req|
          next if req.valid?

          break multiple_result.valid = false
        end
      end

      def collect_peer_ids
        @failed_peer_ids ||= []
        invalid_requests = current_requests.select { |r| !r.valid? && r.safe_retry? }
        return if invalid_requests.blank?
        invalid_requests_peer_ids = invalid_requests.map do |req|
          req.peer.id
        end
        @failed_peer_ids.concat(invalid_requests_peer_ids)
      end

      def assign_peer_ids
        multiple_result.failed_peer_ids = @failed_peer_ids
      end
  end
end
