# frozen_string_literal: true

module SettingsService
  class WebUrl
    def full_host
      return nil if uri&.host.blank?

      "https://" + uri.host + dev_port
    end

    def host
      host = uri&.host
      return nil unless host
      host + dev_port
    end

    private
      def uri
        return @uri if defined? @uri
        return @uri = nil if env_web_url.blank?
        @uri = URI.parse(env_web_url)
      end

      def env_web_url
        @env_web_url ||= Rails.application.secrets.web_url
      end

      def dev_port
        (Rails.env.production? ? "" : ":#{uri.port}")
      end
  end
end
