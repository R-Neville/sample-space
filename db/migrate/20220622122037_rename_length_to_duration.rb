class RenameLengthToDuration < ActiveRecord::Migration[6.1]
  def change
    rename_column :samples, :length, :duration
  end
end
