# frozen_string_literal: true

module ProfilesService
  class ControllerCurrentUser
    attr_reader :session
    def initialize(session)
      @session = session
    end

    def call
      return Current.profile if in_spec_logged_in?

      password_digest = session[:password_digest]
      return nil if password_digest.blank?
      if Current.profile.password_digest != password_digest
        session[:password_digest] = nil
        return nil
      end
      Current.profile
    end

    private
      def in_spec_logged_in?
        Rails.env.test? && ENV["SPEC_LOGGED_IN"]
      end
  end
end
