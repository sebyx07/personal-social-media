# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  include FormsHelper
  include FlashHelper

  before_action :require_current_user
end
