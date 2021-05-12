# frozen_string_literal: true

module SessionsHelper
  def require_current_user
    return if current_user.present?
    return render template: "static/not_register", layout: "logged_out" if Current.profile.blank?
    render template: "static/not_logged_in", layout: "logged_out"
  end

  def is_signed_in?
    current_user.present?
  end

  def current_user
    return @current_user if defined? @current_user
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
end
