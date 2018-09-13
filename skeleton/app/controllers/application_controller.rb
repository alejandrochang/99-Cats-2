class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  helper_method :current_user, :loggedin?

  def login!(user)
    @current_user = user
    session[:session_token] = user.reset_session_token!
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logout!
    @current_user.reset_session_token!
    session[:session_token] = nil
    @current_user = nil
  end

  def loggedin?
    !!@current_user
  end

  def require_login
    redirect_to new_session_url unless loggedin?
  end

  def require_logout
    redirect_to users_url if loggedin?
  end

  # def login_user!
  #   @user = User.find_by_credentials(
  #     params[:user][:username],
  #     params[:user][:password]
  #   )
  #   login!(@user)
  # end
end
