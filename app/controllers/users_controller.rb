class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update index destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find params[:id]
    redirect_to root_path unless @user.activated?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email for activation'
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes user_params
      flash[:success] = 'Successfully update!'
      redirect_to @user
    else
      render :edit
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:succes] = 'User deleted'
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in!'
    redirect_to login_url
  end

  def correct_user
    @user = User.find params[:id]
    return if current_user? @user

    redirect_to root_url
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
