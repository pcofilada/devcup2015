class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :channel

  validates :user, :channel, presence: true
  validates :email, :sms, :mobile, inclusion: { in: %w(true false) }
  validates :user, uniqueness: { scope: :channel, message: 'already subscribed!' }
end
