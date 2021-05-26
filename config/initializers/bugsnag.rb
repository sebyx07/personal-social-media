# frozen_string_literal: true

return unless Rails.env.production?
return unless DeveloperService::IsEnabled.is_enabled?
return unless Rails.application.secrets.bugsnag

Bugsnag.configure do |config|
  config.api_key = Rails.application.secrets.bugsnag
end
