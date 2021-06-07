# frozen_string_literal: true

class Current
  class_attribute :fetch_profile_proc, :fetch_settings_proc if Rails.env.test?
  class << self
    delegate :peer, to: :profile

    def profile
      if Rails.env.test? && fetch_profile_proc.present?
        return fetch_profile_proc.call
      end

      RequestStore[:current_profile] ||= Profile.first
    end

    def settings
      if Rails.env.test? && fetch_settings_proc.present?
        return fetch_settings_proc.call
      end

      RequestStore[:current_settings] ||= Setting.first
    end
  end
end
