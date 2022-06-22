class Sample < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id', required: true
  has_one_attached :audio_file
end
