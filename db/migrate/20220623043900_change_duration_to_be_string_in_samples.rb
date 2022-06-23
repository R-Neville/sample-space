class ChangeDurationToBeStringInSamples < ActiveRecord::Migration[6.1]
  def change
    change_column :samples, :duration, :string
  end
end
