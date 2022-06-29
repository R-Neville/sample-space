class Comment < ApplicationRecord
  belongs_to :sample
  belongs_to :user
end
