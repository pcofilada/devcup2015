class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :logo, :title, :status, :category, :description, :owner, :announcements, :subscribers, :code

  has_one :owner
  has_many :announcements

  def logo
    "#{Rails.application.secrets.host_name}#{object.logo.url(:medium)}"
  end

  def subscribers
    "#{object.subscriptions.count}"
  end
end
