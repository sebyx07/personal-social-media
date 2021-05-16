# frozen_string_literal: true

module ProfilesService
  class RegistrationEnvCheck
    def valid?
      missing_env_vars.blank?
    end

    def missing_env_vars
      return @missing_env_vars if defined? @missing_env_vars
      @missing_env_vars = env_vars.keys.filter_map do |key|
        key if env_vars[key][:value].blank?
      end
    end

    def message_for_var(var)
      env_vars[var][:message]
    end

    private
      def env_vars
        @env_vars ||= {
          DATABASE_MASTER_KEY_LOCKBOX: {
            message: "Secure key to encrypt the database, you can generate it with `Lockbox.generate_key`",
            value: Rails.application.secrets.database_master_key
          },
          INSTALLATION_PASSWORD: {
            message: "Password to protect the installation, you can generate with `rails secret`",
            value: Rails.application.secrets.installation_password
          },
          HCAPTCHA_SECRET_KEY: {
            message: "HCaptcha secret key, you can get key from https://www.hcaptcha.com",
            value: Rails.application.secrets.hcaptcha[:secret_key]
          },
          HCAPTCHA_SITE_KEY: {
            message: "HCaptcha site key, you can get key from https://www.hcaptcha.com",
            value: Rails.application.secrets.hcaptcha[:site_key]
          },
          WEB_URL: {
            message: "The url where the app is running, ex: https://myapp.herokuapp.com",
            value: Rails.application.secrets.web_url
          }
        }
      end
  end
end
