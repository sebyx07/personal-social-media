# frozen_string_literal: true

class SessionsController < ApplicationController
  include HcaptchaHelper
  layout "logged_out"
  skip_before_action :require_current_user, except: :logout
  before_action :check_if_already_registered, only: %i(register register_post)
  before_action :check_if_already_logged_in, only: %i(login login_post)
  before_action :verify_hcaptcha_filter, only: %i(register_post login_post)

  def register
    @profile ||= Profile.new
    @register_env_check = ProfilesService::RegistrationEnvCheck.new

    return unless Rails.env.development?
    @dev_installation_password = Rails.application.secrets.installation_password
  end

  def register_post
    permitted_params = params.require(:profile).permit(:installation_password, :name, :nickname, :email)

    @profile = Profile.new(permitted_params)
    @profile.save!
    RequestStore[:current_profile] = @profile
    set_login_session

    redirect_to whoami_path
  rescue ActiveRecord::RecordInvalid
    register
    render :register
  end

  def login
    return unless Rails.env.development?

    @dev_password = Current.profile&.password_plain
  end

  def login_post
    password = params.require(:login).permit(:password)[:password]

    unless Current.profile&.authenticate(password)
      return redirect_back(fallback_location: sessions_login_path)
    end

    set_login_session

    redirect_to root_path
  end

  def logout
    session[:password_digest] = nil
    redirect_to sessions_login_path
  end

  private
    def set_login_session
      session[:password_digest] = Current.profile.password_digest
    end

    def check_if_already_registered
      redirect_to sessions_login_path if Current.profile.present?
    end

    def check_if_already_logged_in
      redirect_to root_path if is_signed_in?
    end
end
