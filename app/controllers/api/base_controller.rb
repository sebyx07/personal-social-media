# frozen_string_literal: true

module Api
  class BaseController < ActionController::Base
    skip_before_action :verify_authenticity_token
    class InvalidParams < StandardError; end
    include ApiHelper

    alias_method :unsafe_params, :params
    before_action :require_current_peer
    before_action :verify_psm_params_only
  end
end
