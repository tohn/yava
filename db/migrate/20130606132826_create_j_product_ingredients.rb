class CreateJProductIngredients < ActiveRecord::Migration
  def change
    create_table :j_product_ingredients do |t|
      t.integer :product_id, null: false
      t.integer :ingredient_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
