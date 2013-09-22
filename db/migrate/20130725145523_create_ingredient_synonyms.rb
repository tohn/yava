class CreateIngredientSynonyms < ActiveRecord::Migration
  def change
    create_table :ingredient_synonyms do |t|
      t.integer :ingredient_id, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
