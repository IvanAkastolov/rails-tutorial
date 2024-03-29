class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    user = User.find_by(email: email)

    if user&.authenticate(password)
      reset_session
      log_in user

      if params[:session][:remember_me] == "1"
        remember user
      else
        forget user
      end

      redirect_to user
    else
      flash.now[:danger] = "Incorrect login / password!"
      render "new", status: :unauthorized
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end
