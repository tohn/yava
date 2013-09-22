class CreateJProductFeatures < ActiveRecord::Migration
  def change
    create_table :j_product_features do |t|
      t.integer :product_id, null: false
      t.integer :feature_id, null: false
      t.integer :user_id, null: false
      
      t.timestamps
    end
  end
end
