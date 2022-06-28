class AddBlurbToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :blurb, :text, :limit => 150
  end
end
