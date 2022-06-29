class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_one_attached :avatar
  validates :avatar, file_size: { less_than_or_equal_to: 5.megabytes },
              file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }
  
  has_many :samples, dependent: :destroy
  has_many :downloads, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :received_notifications, foreign_key: 'for_id', class_name: 'Notification', dependent: :destroy
  has_many :created_notifications, foreign_key: 'from_id', class_name: 'Notification'
  has_many :comments, dependent: :destroy
end
