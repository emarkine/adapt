class UsersController < ApplicationController
  skip_before_action :require_login, only: [:index, :new, :create]

  before_action do
    @user = User.find(params[:id]) unless params[:id].blank?
  end

  def new
    @user = User.new
  end

  def show

  end

  def profile
    @user = current_user
    @object = @user
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
