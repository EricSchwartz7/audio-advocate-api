class AddDateToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :date, :date
  end
end
