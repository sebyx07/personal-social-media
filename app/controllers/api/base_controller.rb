# frozen_string_literal: true

module Api
  class BaseController < ActionController::Base
    attr_accessor :hook_into_current_peer if Rails.env.test?

    skip_before_action :verify_authenticity_token
    class InvalidParams < StandardError; end
    include ApiHelper

    alias_method :unsafe_params, :params
    before_action :require_current_peer
    before_action :verify_psm_params_only
  end
end
