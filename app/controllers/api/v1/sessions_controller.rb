class Api::V1::SessionsController < ApplicationController

  def create
    password = params[:user][:password]
    email = params[:user][:email]
    user = User.find_by(email: email)

    if user && user.valid_password?(password)
      sign_in user
      user.generate_authentication_token
      user.save
      
      render json: user, status: 200
    else
      render json: { errors: "Invalid email or password" }, status: 422
    else
    end
  end
end
