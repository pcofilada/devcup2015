class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :channel_id, :sms, :mobile, :email, :status, :created_at

  def created_at
    object.created_at.strftime("%B %d, %Y")
  end
end
