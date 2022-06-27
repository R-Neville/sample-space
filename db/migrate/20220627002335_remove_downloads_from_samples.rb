class RemoveDownloadsFromSamples < ActiveRecord::Migration[6.1]
  def change
    remove_column :samples, :downloads
  end
end
