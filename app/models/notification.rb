class Notification < ApplicationRecord
  belongs_to :for, foreign_key: 'for_user_id', class_name: 'User'
  belongs_to :from, foreign_key: 'from_user_id', class_name: 'User'
  belongs_to :sample
end
