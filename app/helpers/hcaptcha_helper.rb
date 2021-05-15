# frozen_string_literal: true

module HcaptchaHelper
  def safe_hcaptcha_tags(options = {})
    config = Hcaptcha.configuration
    return if config.secret_key.blank? || config.site_key.blank?

    hcaptcha_tags(options)
  end
end
