# frozen_string_literal: true

class EveryHourWorker < ApplicationWorker
  def perform
    if DeveloperService::IsEnabled.is_enabled?
      perform_for_dev
    end
  end

  def perform_for_dev
    DatabaseWorker::PgheroWorker.perform_async
  end
end
