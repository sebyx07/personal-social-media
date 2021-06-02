# frozen_string_literal: true

module TestService
  class SessionTest
    include Singleton

    attr_reader :my_profile, :my_settings
    attr_accessor :text_ctx

    def initialize
      reset_full!
    end

    def take_over_wrap!
      Current.fetch_profile_proc = -> do
        other_profile
      end

      Current.fetch_settings_proc = -> do
        other_settings
      end
      yield.tap do
        _reset_current_procs
      end
    end

    def other_profile
      return @other_profile if @other_profile.present?
      @other_profile = FactoryBot.create(:profile).tap do |profile|
        peer = Peer.last
        peer.update!(is_me: false)
        profile.instance_variable_set("@peer", peer)
      end
    end

    def other_settings
      @other_settings ||= FactoryBot.create(:setting)
    end

    def reset_full!
      @my_profile = FactoryBot.create(:profile).tap do |profile|
        profile.instance_variable_set("@peer", Peer.last)
      end
      @my_settings = FactoryBot.create(:setting)
      reset!
    end

    def reset!
      @other_profile = nil
      @other_settings = nil

      _reset_current_procs
    end

    private
      def _reset_current_procs
        Current.fetch_profile_proc = nil
        Current.fetch_settings_proc = nil
      end
  end
end
