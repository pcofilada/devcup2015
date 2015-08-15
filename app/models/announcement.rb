class Announcement < ActiveRecord::Base
  belongs_to :channel

  validates :title, :channel, presence: true
  validates :message, presence: true, length: { maximum: 140 }
end
