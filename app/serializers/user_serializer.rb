class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :mobile_number, :email, :password, :avatar, :auth_token, :facebook_token

  def avatar
    "#{Rails.application.secrets.host_name}#{object.avatar.url(:original)}"
  end

end
