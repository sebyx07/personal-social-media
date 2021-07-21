# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Psm
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.autoload_paths << Rails.root.join("app" "storage")
    config.autoload_paths << Rails.root.join("app" "schmooze")
    config.autoload_paths << Rails.root.join("app" "sucker_punch")
    config.autoload_paths << Rails.root.join("lib", "utils")

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**/*.{rb,yml}")]
    config.i18n.default_locale = :en

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.time_zone = "UTC"
    config.active_record.default_timezone = :utc
    config.active_job.queue_adapter = :sidekiq

    config.assets.configure do |env|
      env.export_concurrent = false
    end
  end
end
