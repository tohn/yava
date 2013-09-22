class CreateNutvals < ActiveRecord::Migration
  def change
    create_table :nutvals do |t|
      t.string :energy
      t.string :proteins
      t.string :carbohydrates
      t.string :sugar
      t.string :fat
      t.string :saturated
      t.string :monounsaturated
      t.string :polyunsaturated
      t.string :roughages
      t.string :natrium
      t.string :alcohol
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
