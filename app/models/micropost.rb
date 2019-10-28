class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return unless picture.size > 1.megabyte

    errors.add(:picture, 'shoulde be less than 1MB')
  end
end
