class Channel < ActiveRecord::Base
  belongs_to :owner, polymorphic: true

  before_save :generate_code
  
  has_many :announcements
  has_many :subscriptions
  has_many :users, through: :subscriptions

  has_attached_file :logo, :styles => { :medium => "250x250>", :thumb => "50x50#" }
  validates_attachment_content_type :logo, :content_type => /^image\/(png|jpg|jpeg)/

  validates :title, :owner, :logo, presence: true
  validates :description, presence: true, length: { maximum: 140 }
  validates :status, presence: true, inclusion: { in: %w(active inactive), message: "%{value} is not a valid status." }
  validates :category, presence: true, inclusion: { in: %w(private public), message: "%{value} is not a valid category." }
  validates :verified, inclusion: { in: [true, false] } 

private

  def generate_code
    if self.category === 'private' && self.code.nil?
      self.code = Devise.friendly_token[0, 10]
    end
  end
end
