class Sample < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id', required: true
  has_one_attached :audio_file
  validates_presence_of :audio_file, file_content_type: { allow: ['audio/x-wav'] }
  validates_presence_of :name
  acts_as_taggable_on :tags
  has_many :downloads, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :comments, dependent: :destroy

  ActsAsTaggableOn.delimiter = ' '
end
