class User < ActiveRecord::Base
  before_create :generate_authentication_token

  has_many :channels, as: :owner

  has_attached_file :avatar, :styles => { :thumb => "50x50#" }
  validates_attachment_content_type :avatar, :content_type => /^image\/(png|jpg|jpeg)/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, presence: true

  def generate_authentication_token
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  def self.facebook(token, profile)
    where(email: profile['email']).first_or_create do |user|
      user.first_name = profile['first_name']
      user.last_name = profile['last_name']
      user.password = Devise.friendly_token[0, 20]
      user.avatar = proccess_uri(profile['picture']['data']['url'])
    end
  end

private

def self.proccess_uri(uri)
    avatar_url = URI.parse(uri)
    avatar_url.scheme = 'https'
    avatar_url.to_s
  end

end
