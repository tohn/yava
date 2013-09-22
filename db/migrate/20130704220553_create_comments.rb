class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment, null: false
      t.integer :user_id, null: false
      t.integer :veganity_id, null: false, default: 4
      t.integer :comment_id
      t.integer :product_id, null: false

      t.timestamps
    end
  end
end
