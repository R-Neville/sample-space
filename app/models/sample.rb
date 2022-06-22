class Sample < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id', required: true
  has_one_attached :audio_file
end
