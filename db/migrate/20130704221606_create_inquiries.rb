class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.boolean :typ, null: false, default: false
      t.text :text, null: false
      t.integer :user_id, null: false
      t.boolean :highlight, null: false, default: false
      t.integer :veganity_id, null: false, default: 4
      t.integer :product_id, null: false
      t.boolean :seen, null: false, default: false

      t.timestamps
    end
  end
end
