class UsersController < ApplicationController
  before_action do
    redirect_to cats_url if logged_in?
  end

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login_user!(@user)
      redirect_to cats_url
    else
      #flash
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
