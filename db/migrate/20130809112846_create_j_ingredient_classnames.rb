class CreateJIngredientClassnames < ActiveRecord::Migration
  def change
    create_table :j_ingredient_classnames do |t|
      t.integer :ingredient_id, null: false
      t.integer :classname_id, null: false

      t.timestamps
    end
  end
end
