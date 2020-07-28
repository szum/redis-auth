module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:user_return_to] || default)
    session.delete(:user_return_to)
  end

  private
  def require_authentication
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def store_location
    session["user_return_to"] = request.original_url if request.get? && !external?
  end

  def external?
    URI.parse(request.original_url).host.to_s != request.host
  end
end
