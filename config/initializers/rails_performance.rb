# frozen_string_literal: true

return if Rails.application.secrets.redis[:url].blank?

RailsPerformance.setup do |config|
  config.redis = Redis::Namespace.new("#{Rails.env}-rails-performance", redis: Redis.new(RedisService::Url.build_sidekiq_config))
  config.duration = DeveloperService::IsEnabled.is_enabled? ? 72.hours : 8.hours
  config.enabled = true
end if defined? RailsPerformance
