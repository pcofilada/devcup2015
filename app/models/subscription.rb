class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel

  validates :user, :channel, presence: true
  validates :email, :sms, :mobile, inclusion: { in: [true, false] }
  validates :status, presence: true, inclusion: { in: %w(active inactive), message: "%{value} is not a valid status." }
  validates :user, uniqueness: { scope: :channel, message: 'already subscribed!' }

  scope :sms_enabled, -> { where(sms: true, status: 'active') }
  scope :email_enabled, -> { where(email: true, status: 'active') }
  scope :mobile_enabled, -> { where(mobile: true, status: 'active') }
end
