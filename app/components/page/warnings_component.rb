# frozen_string_literal: true

module Page
  class WarningsComponent < ViewComponent::Base
    attr_reader :warnings, :action_name
    def initialize(action_name:)
      @warnings = []
      @action_name = action_name
      look_for_warnings
    end

    def show_anything?
      warnings.present?
    end

    private
      def look_for_warnings
        check_for_plain_password
      end

      def check_for_plain_password
        return if Current.profile.password_plain.blank?
        return if action_name == "setup_recovery"

        warnings << Warning.new("Please finish your account recovery", level: :high, url: :setup_recovery_profile_path)
      end

      class Warning
        include Rails.application.routes.url_helpers
        attr_reader :message, :level, :url
        def initialize(message, level:, url: "#")
          @message = message
          @level = level
          @url = url
        end

        def display_url
          send(url)
        end

        def text_klass
          if level == :high
            "text-red-500 font-bold"
          end
        end
      end
  end
end
