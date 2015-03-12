class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= Session.find_by_token(session[:token]).try(:user)
  end

  def logged_in?
    current_user != nil
  end

  def login_user!(user, options)
    session[:token] = user.add_session_token!(options)
    session[:user] = user.id
  end
end
