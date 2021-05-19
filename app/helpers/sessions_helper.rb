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
    @current_user = ProfilesService::ControllerCurrentUser.new(session).call
  end
end
