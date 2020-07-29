class UsersController < ApplicationController
  before_action :require_authentication, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    result = CreateUser.call(user_params)
    if result.success?
      log_in(result.user_id)
      flash[:success]
      render json: { user: result }
    else
      flash[:error] = result.error_messages.join(' ')
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
