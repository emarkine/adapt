class UsersController < ApplicationController
  skip_before_action :require_login, only: [:index, :new, :create]

  before_action do
    @user = User.find(params[:id]) unless params[:id].blank?
  end

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = t(:message_create, :model => @user.name)
      redirect_to @broker
    else
      render action: :new
    end
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = t(:message_update, :model => @user.name)
      redirect_to @user
    else
      render action: :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = t(:message_destroy, :model => @user.name)
    redirect_to action: :index
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
