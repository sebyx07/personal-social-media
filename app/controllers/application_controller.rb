# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  include FormsHelper

  before_action :require_current_user
end
