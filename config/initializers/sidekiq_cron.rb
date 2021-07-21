# frozen_string_literal: true

return if Rails.env.test?
return if Rails.application.secrets.redis[:url].blank?
return if ENV["IS_DEPLOYING"]
return unless Sidekiq.server?

schedule_file = "config/schedule.yml"

unless Rails.env.production?
  Sidekiq.redis { |conn| conn.flushdb }
end

Sidekiq::Cron::Job.destroy_all!

if File.exist?(schedule_file)
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
