class CreateTypeRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :type_ratings do |t|
      t.integer :rating_id
      t.integer :type_id

      t.timestamps
    end
  end
end
