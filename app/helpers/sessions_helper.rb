module SessionsHelper
  def current_user
    @current_user ||= User.find_by(name: session[:user_name])
  end

  def logged_in?
    !!current_user
  end
end