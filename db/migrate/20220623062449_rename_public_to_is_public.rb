class RenamePublicToIsPublic < ActiveRecord::Migration[6.1]
  def change
    rename_column :samples, :public, :is_public
  end
end
