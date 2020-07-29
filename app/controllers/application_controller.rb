class ApplicationController < ActionController::Base

  private
  def log_in(user_id)
    session[:user_id] = user_id
  end
end
