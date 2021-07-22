# frozen_string_literal: true

module DeveloperService
  class IsEnabled
    class << self
      def is_enabled?
        ENV["DEVELOPER"] == "true"
      end
    end
  end
end
