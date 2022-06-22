class RenameCreatorIdToUserId < ActiveRecord::Migration[6.1]
  def change
    rename_column :samples, :creator_id, :user_id
  end
end
