class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.string :name, null: false
      t.string :street
      t.integer :city_id
      t.string :http
      t.string :email
      t.string :tel
      t.string :fax
      t.string :image
      t.integer :user_id, null: false

      t.timestamps
    end
    add_attachment :manufacturers, :image
  end
end
