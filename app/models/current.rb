# frozen_string_literal: true

class Current
  class << self
    delegate :peer, to: :profile

    def profile
      return @profile if defined? @profile
      @profile = __first_profile
    end

    def fresh_profile
      return profile if Rails.env.test?
      __first_profile
    end

    def settings
      return @settings if defined? @settings
      @settings = Setting.first
    end

    def __set_manually_profile(profile)
      @profile = profile
    end

    def __set_manually_settings(settings)
      @settings = settings
    end

    def __first_profile
      Profile.first
    end
  end
end
