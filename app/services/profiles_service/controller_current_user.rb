# frozen_string_literal: true

module ProfilesService
  class ControllerCurrentUser
    attr_reader :session
    def initialize(session)
      @session = session
    end

    def call
      return Current.profile if in_spec_logged_in?

      return_profile_if_valid_password_digest(Current.profile)
    end

    def call_from_action_cable
      return Profile.first if in_spec_logged_in?

      return_profile_if_valid_password_digest(Profile.first)
    end

    private
      def in_spec_logged_in?
        Rails.env.test? && ENV["SPEC_LOGGED_IN"]
      end

      def return_profile_if_valid_password_digest(profile)
        password_digest = session[:password_digest]
        return nil if password_digest.blank? || profile.blank?
        if profile.password_digest != password_digest
          session[:password_digest] = nil
          return nil
        end
        profile
      end
  end
end
