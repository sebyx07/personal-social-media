# frozen_string_literal: true

Sidekiq::Throttled.setup!

return if Rails.env.test?
return if Rails.application.secrets.redis[:url].blank?
Redis.exists_returns_integer = false

Sidekiq.configure_server do |config|
  config.redis = RedisService::Url.build_sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = RedisService::Url.build_sidekiq_config
end

if Rails.env.production?
  return unless DeveloperService::IsEnabled.is_enabled?
  return unless Rails.application.secrets.bugsnag

  Sidekiq.default_worker_options = { "backtrace" => 20 }

  Sidekiq.configure_server do |config|
    config.error_handlers << Proc.new { |ex| Bugsnag.notify(ex) }
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add RailsServerMonitor::SidekiqMiddleware
    chain.add SafeFileSidekiqMiddleware
  end
end
