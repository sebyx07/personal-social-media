module SettingsService
  class WebUrl
    attr_reader :uri
    def initialize
      @uri = URI.parse(Rails.application.secrets.web_url)
    end

    def full_host
      return nil if uri.host.blank?

      "https://" + uri.host + (Rails.env.production? ? "" : ":#{uri.port}")
    end
  end
end