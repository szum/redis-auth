module SessionsHelper
  def current_user
    if session[:user_id]
      @current_user ||= REDIS.hmget("user:#{session[:user_id]}", 'id', 'name')
    end
  end

  def log_in(user_id)
    session[:user_id] = user_id
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out!
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  private
  def require_authentication
    unless logged_in?
      store_location
      flash[:danger] = "You need to be logged in."
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
