class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :brand
      t.string :category
      t.string :alt_category
      t.string :other_attribute
      t.integer :type_id

      t.timestamps
    end
  end
end
