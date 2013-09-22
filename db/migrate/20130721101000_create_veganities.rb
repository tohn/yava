class CreateVeganities < ActiveRecord::Migration
  def change
    create_table :veganities do |t|
      t.string :name, null: false
      t.text :description
      t.string :image
      t.string :color, null: false

      t.timestamps
    end
    add_attachment :veganities, :image
  end
end
