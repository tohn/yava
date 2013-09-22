class CreateJProductLabels < ActiveRecord::Migration
  def change
    create_table :j_product_labels do |t|
      t.integer :product_id, null: false
      t.integer :label_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
