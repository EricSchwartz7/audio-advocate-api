class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.string :name
      t.integer :number
      t.integer :type_rating_id
      t.integer :review_id

      t.timestamps
    end
  end
end
