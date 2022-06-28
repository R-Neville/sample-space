class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :for, null: false, foreign_key: { to_table: :users }
      t.references :from, null: false, foreign_key: { to_table: :users }
      t.references :sample, null: false, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
