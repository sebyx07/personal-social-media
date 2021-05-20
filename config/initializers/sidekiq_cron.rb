# frozen_string_literal: true

return if Rails.env.test?

schedule_file = "config/schedule.yml"

if Sidekiq.server?
  Sidekiq::Cron::Job.destroy_all!
end

if File.exist?(schedule_file) && Sidekiq.server? && Rails.env.production?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

unless Rails.env.production?
  Sidekiq.redis { |conn| conn.flushdb }
end
