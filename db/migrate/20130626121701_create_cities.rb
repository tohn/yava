class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.integer :postcode
      t.string :name
      t.references :country, index: true
      t.integer :user_id

      t.timestamps
    end
  end
end
