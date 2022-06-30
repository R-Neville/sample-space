class Comment < ApplicationRecord
  belongs_to :sample
  belongs_to :user
  has_rich_text :content
  validates_presence_of :content
end
