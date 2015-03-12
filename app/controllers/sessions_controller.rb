class SessionsController < ApplicationController
  before_action only: [:new, :create] do
    redirect_to cats_url if logged_in?
  end

  def new
    render :new
  end

  def create
    # byebug
    environment = request.env["HTTP_USER_AGENT"]
    location = request.location.city
    options = { environment: environment, location: location }
    @user = User.find_by_credentials(user_params["username"], user_params["password"])
    if @user.nil?
      #flash
      redirect_to new_user_url
    else
      login_user!(@user, options)
      redirect_to cats_url
    end
  end

  def destroy
    current_user.delete_session_token!(session_params["token"])
    if session[:token] == session_params["token"]
      session[:token] = nil
      session[:user] = nil
    end
    redirect_to cats_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def session_params
    params.require(:session).permit(:token)
  end
end
