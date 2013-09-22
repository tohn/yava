class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :fullname, null: false
      t.boolean :aktiv, default: true

      t.timestamps
    end
  end
end
