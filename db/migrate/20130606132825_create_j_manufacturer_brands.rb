class CreateJManufacturerBrands < ActiveRecord::Migration
  def change
    create_table :j_manufacturer_brands do |t|
      t.integer :manufacturer_id, null: false
      t.integer :brand_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
