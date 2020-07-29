class SessionsController < ApplicationController
  def new
  end

  def create
    if user && has_valid_password?
      log_in(user.first)
      render json: { user: user, success: "Welcome!" }
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    session.delete(:current_user_id)
    # Clear the memoized current user
    @_current_user = nil
    redirect_to root_url
  end

  private

  def user
    @user = REDIS.hget("#{params[:session][:name].downcase}", 'id', 'name', 'email', 'password')
  end

  def

  def has_valid_password?
    BCrypt::Password.new(@user.last) == [:session][:password]
  end
end
