class UsersController < ApplicationController
  include SessionsHelper

  before_action :require_authentication, only: [:show]

  def show
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    result = CreateUser.call(user_params)
    if result.success?
      log_in(result.user_id)
      flash[:success] = "You've successfully created an account!"
      redirect_to user_path(result.user_id)
    else
      flash[:danger] = result.error_messages.join(' ')
      redirect_to signup_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
