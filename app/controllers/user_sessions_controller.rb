class UserSessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    if @user = login(user_params[:email], user_params[:password])
      redirect_back_or_to(admin_root_path, notice: 'Login successful')
    else
      @user = User.new
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "You've been logged out"
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
