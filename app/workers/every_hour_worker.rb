# frozen_string_literal: true

class EveryHourWorker < ApplicationWorker
  def perform
    if DeveloperService::IsEnabled.is_enabled?
      perform_for_dev
    end

    perform_cleanup
  end

  private
    def perform_cleanup
      CleanupWorkers::CleanDanglingUploadFilesWorker.perform_async
    end

    def perform_for_dev
      DatabaseWorker::PgheroWorker.perform_async
    end
end
