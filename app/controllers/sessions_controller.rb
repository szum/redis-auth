class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  def create
    if user && has_valid_password?
      log_in(user_id)
      respond_to do |format|
        format.html { redirect_to user_path(user_id) }
        format.json { render json: { user: user, success: "Welcome!" }, status: 200 }
      end
    else
      message = 'Invalid user name & password combination'
      flash.now[:danger] = message
      respond_to do |format|
        format.html {
          flash[:error] = message
          redirect_to login_path
        }
        format.json { render json: { errors: [message] }, status: 401 }
      end
    end
  end

  def destroy
    log_out!
    redirect_to signup_path
  end

  private

  def session_params
    params.require(:session).permit(:name, :password)
  end

  def user
    @user = REDIS.hmget("user:#{user_id}", 'id', 'name', 'password')
  end

  def user_id
    @user_id ||= REDIS.hget('users:', session_params[:name].downcase)
  end

  def has_valid_password?
    BCrypt::Password.new(@user.last) == session_params[:password]
  end
end
