module SessionsHelper
  def login_in(user)
    session[:user_id] = user.id
  end

  def log_out
    reset_session
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end
end
