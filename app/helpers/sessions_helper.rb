# frozen_string_literal: true

module SessionsHelper
  def require_current_user
    return if current_user.present?
    return redirect_to sessions_register_path if Current.profile.blank?
    redirect_to sessions_login_path(redirect_to: request.path)
  end

  def is_signed_in?
    current_user.present?
  end

  def current_user
    return @current_user if defined? @current_user
    return @current_user = Current.profile if in_spec_logged_in?

    password_digest = session[:password_digest]
    return @current_user = nil if password_digest.blank?
    if Current.profile.password_digest != password_digest
      session[:password_digest] = nil
      return @current_user = nil
    end
    @current_user = Current.profile
  end

  def clean_current
    Current.cleanup
  end

  private
    def in_spec_logged_in?
      Rails.env.test? && ENV["SPEC_LOGGED_IN"]
    end
end
