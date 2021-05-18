# frozen_string_literal: true

class Current
  class << self
    def profile
      return @profile if defined? @profile
      @profile = Profile.first
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
  end
end
