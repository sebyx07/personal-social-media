# frozen_string_literal: true

module DeveloperService
  class HandleError
    include Singleton
    attr_reader :error

    class << self
      def handle_error(error)
        instance.handle_error(error)
      end
    end

    def handle_error(error)
      @error = error

      return handle_local unless Rails.env.production?

      handle_deployed
    end

    def handle_local
      raise error
    end

    def handle_deployed
      return if Rails.application.secrets.bugsnag.blank?

      Bugsnag.notify(error)
    end
  end
end
