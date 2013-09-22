class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.integer :manufacturer_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
