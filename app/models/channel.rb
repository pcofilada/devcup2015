class Channel < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  validates :title, :owner, presence: true
  validates :description, presence: true, length: { maximum: 140 }
  validates :status, presence: true, inclusion: { in: %w(STATUS), message: "%{value} is not a valid status." }
  validates :category, presence: true, inclusion: { in: %w(CATEGORY), message: "%{value} is not a valid category." }

  STATUS = ['active', 'inactive']
  CATEGORY = ['private', 'public']
end
