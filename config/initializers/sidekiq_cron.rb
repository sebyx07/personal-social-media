# frozen_string_literal: true

return if Rails.env.test?
return if Rails.application.secrets.redis[:url].blank?
return if ENV["IS_DEPLOYING"]

schedule_file = "config/schedule.yml"

unless Rails.env.production? && Sidekiq.server?
  Sidekiq.redis { |conn| conn.flushdb }
end

if Sidekiq.server?
  Sidekiq::Cron::Job.destroy_all!
end

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
