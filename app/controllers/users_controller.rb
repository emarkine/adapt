class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def profile
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
