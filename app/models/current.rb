# frozen_string_literal: true

class Current
  class << self
    def profile
      return @profile if instance_variable_defined?(:@profile)
      @profile = Profile.first
    end

    def settings
      return @settings if instance_variable_defined?(:@settings)
      @settings = Setting.first
    end

    def __set_manually_profile(profile)
      return remove_instance_variable(:@profile) if profile.nil?
      @profile = profile
    end

    def __set_manually_settings(settings)
      return remove_instance_variable(:@settings) if settings.nil?
      @settings = settings
    end

    def cleanup
      __set_manually_profile(nil)
      __set_manually_settings(nil)
    end
  end
end
