class SessionsController < ApplicationController
  layout "logged_out"
  skip_before_action :require_current_user, except: :logout

  def login_post
    password = params.require(:login).permit(:password)[:password]

    unless Current.profile&.authenticate(password)
      return redirect_back(fallback_location: sessions_login_path)
    end

    session[:password_digest] = Current.profile.password_digest
    redirect_to root_path
  end

  def logout
    session[:password_digest] = nil
    redirect_to :login
  end
end