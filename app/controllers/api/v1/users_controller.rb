class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token, only: :update
  
  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: 201
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def update
    user = current_user

    if user.update(user_params)
      render json: user, status: 201
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

private
  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :mobile_number, :avatar)
  end
end
