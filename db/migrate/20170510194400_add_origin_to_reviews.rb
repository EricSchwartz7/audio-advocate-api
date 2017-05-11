class AddOriginToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :origin, :string
  end
end
