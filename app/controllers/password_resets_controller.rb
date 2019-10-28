class PasswordResetsController < ApplicationController

  before_action :set_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email]
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instruction'
      redirect_to root_path
    else
      flash.now[:danger] = 'Email address not found'
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render :edit
    elsif @user.update_attributes(user_params)
      @user.update_attribute(:reset_digest, nil)
      log_in @user
      flash[:success] = 'Password has been reset'
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'Password reset has expired.'
    redirect_to new_password_reset_path
  end

  def user_params
    params.require(:user)
          .permit(:password, :password_confirmation)
  end
end
