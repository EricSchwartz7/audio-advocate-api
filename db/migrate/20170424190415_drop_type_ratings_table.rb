class DropTypeRatingsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :type_ratings
  end
end
