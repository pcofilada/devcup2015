module Authenticable

  def current_user 
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token
    render json: { errors: "Not Authorized!" }, status: :unauthorized unless current_user.present?
  end

  def user_signed_in?
    current_user.present?
  end

  def current_channel
    @current_channel ||= Channel.find(params[:id])
  end

  def authenticate_private_channel
    if current_channel.category == 'private' && current_channel.code != params[:code]
      render json: { errors: "Not Authorized!" }, status: :unauthorized
    end
  end

end
