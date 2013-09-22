class CreateJIngredientProducts < ActiveRecord::Migration
  def change
    create_table :j_ingredient_products do |t|
      t.integer :ingredient_id, null: false
      t.integer :product_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
