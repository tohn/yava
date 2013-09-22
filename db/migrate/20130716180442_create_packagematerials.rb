class CreatePackagematerials < ActiveRecord::Migration
  def change
    create_table :packagematerials do |t|
      t.string :name, null: false
      t.text :description
      t.string :http
      t.integer :user_id, null: false
      t.string :image
      t.string :abbr
      t.string :code

      t.timestamps
    end
    add_attachment :packagematerials, :image
  end
end
