Hcaptcha.configuration.tap do |c|
  c.secret_key = Rails.application.secrets.hcaptcha[:secret_key]
  c.site_key = Rails.application.secrets.hcaptcha[:site_key]
end