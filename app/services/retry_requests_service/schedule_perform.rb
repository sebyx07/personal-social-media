# frozen_string_literal: true

module RetryRequestsService
  class SchedulePerform
    DELAY_SCHEDULE = {
      1 => 30.seconds,
      2 => 2.minutes,
      3 => 30.minutes,
      4 => 6.hours,
      max: 24.hours
    }

    attr_reader :retry_request
    def initialize(retry_request)
      @retry_request = retry_request
    end

    def call!
      retry_request.update!(status: :pending)
      enqueue
    end

    def enqueue
      return RetryRequestsWorker::ExecuteRequest.perform_async(retry_request.id) if delay.blank?
      RetryRequestsWorker::ExecuteRequest.perform_in(delay, retry_request.id)
    end

    def delay
      return nil if retry_request.retries == 0
      return @delay if defined? @delay

      @delay = DELAY_SCHEDULE[retry_request.retries] || DELAY_SCHEDULE[:max]
    end
  end
end
