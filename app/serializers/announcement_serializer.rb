class AnnouncementSerializer < ActiveModel::Serializer
  attributes :id, :title, :message, :channel_id, :created_at

  def created_at
    object.created_at.strftime("%B %d, %Y")
  end
end
