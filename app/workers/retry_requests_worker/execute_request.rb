# frozen_string_literal: true

module RetryRequestsWorker
  class ExecuteRequest < ApplicationWorker
    sidekiq_options retry: 0, queue: :http_retries
    attr_reader :retry_request

    def perform(retry_request_id)
      @retry_request = RetryRequest.find_by(id: retry_request_id)
      return if retry_request.blank?

      retry_request.update!(status: :running)

      result = retry_request.execute
      return handle_success if result.valid?
      return handle_too_many_retries if retry_request.max_retries?

      handle_retry
    end

    private
      def handle_success
        retry_request.update!(status: :completed)
      end

      def handle_too_many_retries
        retry_request.increment(:retries)
        retry_request.status = :failed
        retry_request.save!
      end

      def handle_retry
        retry_request.increment(:retries)
        retry_request.peer_ids = result.failed_peer_ids
        retry_request.save!

        retry_request.perform
      end
  end
end
