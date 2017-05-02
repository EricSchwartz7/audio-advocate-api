class RemoveNameFromRatings < ActiveRecord::Migration[5.0]
  def change
    remove_column :ratings, :name
  end
end
