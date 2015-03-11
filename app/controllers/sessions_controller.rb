class SessionsController < ApplicationController
  before_action only: [:new, :create] do
    redirect_to cats_url if logged_in?
  end

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(session_params["username"], session_params["password"])
    if @user.nil?
      #flash
      redirect_to new_user_url
    else
      login_user!(@user)
      redirect_to cats_url
    end
  end

  def destroy
    session[:token] = nil
    current_user.reset_session_token!
    session[:user] = nil
    redirect_to cats_url
  end

  private

  def session_params
    params.require(:user).permit(:username, :password)
  end
end
