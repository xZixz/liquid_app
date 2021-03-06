class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by_email session_params[:email]
    if @user&.authenticate(session_params[:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = 'Account not activated!'
        message += ' Check your email for activation link!'
        flash[:danger] = message
        redirect_to root_path
      end
    else
      flash.now[:danger] = 'Not a valid user!'
      render :new
    end

  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session)
          .permit(:email, :password, :remember_me)
  end
end
