class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by_email session_params[:email] 
    if user&.authenticate(session_params[:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Not a valid user!'
      render :new
    end

  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session)
          .permit(:email, :password)
  end
end
