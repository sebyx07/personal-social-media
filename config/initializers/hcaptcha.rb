# frozen_string_literal: true

Hcaptcha.configuration.tap do |c|
  secret_key = Rails.application.secrets.hcaptcha[:secret_key]
  secret_key = secret_key.is_a?(String) ? secret_key : secret_key&.to_s(16)

  c.secret_key = secret_key
  c.site_key = Rails.application.secrets.hcaptcha[:site_key]
end
