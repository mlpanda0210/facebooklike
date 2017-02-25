class Topic < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  validates :content, presence: true
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  def like_topic(user_id)
    likes.find_by(user_id: user_id)
  end
end
