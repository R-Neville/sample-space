class CreateSamples < ActiveRecord::Migration[6.1]
  def change
    create_table :samples do |t|
      t.references :creator, null: false, foreign_key: {to_table: :users}
      t.string :name
      t.text :description
      t.integer :length
      t.integer :sample_rate
      t.integer :bit_depth
      t.integer :likes
      t.integer :downloads
      t.float :price

      t.timestamps
    end
  end
end
