# frozen_string_literal: true

module Api
  class BaseController < ActionController::Base
    class InvalidParams < Exception; end
    include ApiHelper

    alias_method :unsafe_params, :params
    before_action :verify_psm_params_only
  end
end
