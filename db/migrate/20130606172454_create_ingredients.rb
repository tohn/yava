class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name, null: false
      t.text :description
      t.integer :veganity_id, null: false, default: 4
      t.string :image
      t.string :source
      t.integer :user_id, null: false
      #t.integer :classname_id
      t.boolean :hide, null: false, default: false
      t.boolean :fixed, null: false, default: false
      #t.timestamp :lastveganityupdate

      t.timestamps
    end
    add_attachment :ingredients, :image
  end
end
