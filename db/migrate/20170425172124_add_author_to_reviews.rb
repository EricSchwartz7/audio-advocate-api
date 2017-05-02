class AddAuthorToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :author, :string
  end
end
