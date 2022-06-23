class AddPublicToSamples < ActiveRecord::Migration[6.1]
  def change
    add_column :samples, :public, :boolean
  end
end
