class UsersController < ApplicationController
  skip_before_action :require_login, only: [:create]
  skip_before_action :check_user, only: %i[index]

  def index
    users = User.all
    if users
      render json: {
        users:
      }
    else
      render json: {
        status: 500,
        errors: ['no users found']
      }
    end
  end

  def show
    if user
      render json: user
    else
      render json: {
        status: 500,
        errors: ['user not found']
      }
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      login!
      render json: {
        status: :created,
        user:
      }
    else
      render json: {
        status: 500,
        errors: user.errors.full_messages
      }
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
