# frozen_string_literal: true

class SafeFileSidekiqMiddleware
  def call(*_args)
    return yield if Rails.env.test?
    yield.tap do
      SafeFile.close_opened_files!
      SafeTempfile.clean_safe_temp_files!(sidekiq: true)
    end
  end
end
