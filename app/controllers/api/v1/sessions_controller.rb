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
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_authentication_token
    user.save

    head 204
  end

  def facebook_login
    fb_token = request.headers['Facebook-Access-Token']
    graph = Koala::Facebook::API.new(fb_token)
    profile = graph.get_object("me?fields=id,email,first_name,last_name,picture{url}")
    old_user = User.find_by(email: profile['email'])

    if old_user && old_user.facebook_token.nil?
      render json: { errors: "Email already registered!" }, status: 422
      return true
    end

    if fb_token.present?
      user = User.facebook(fb_token, profile)
      sign_in user
      user.generate_authentication_token
      user.facebook_token = fb_token
      user.save

      render json: user, status: 200
    else
      render json: { errors: "Unexpected error occured!" }, status: 422
    end
  end

end
