class Channel < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  validates :title, :owner, presence: true
  validates :description, presence: true, length: { maximu: 140 }
  validates :status, presence: true, inclusion: { in: STATUS, message: "%{value} is not a valid status." }
  validates :category, presence: true, inclusion: { in: CATEGORY, message: "%{value} is not a valid status." }

  STATUS = ['active', 'inactive']
  CATEGORY = ['private', 'public']
end
