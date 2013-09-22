class CreateProducts < ActiveRecord::Migration
  def change
	# https://moeffju.net/blog/using-bigint-columns-in-rails-migrations
    create_table :products do |t|
      t.integer :gtin, :limit => 8, null: false
      t.string :image
      t.string :name, null: false
      t.text :description
      t.integer :category_id
      t.integer :nutval_id
      t.integer :packagematerial_id
      t.string :packagesize
      t.integer :country_id
      t.integer :brand_id
      t.integer :veganity_ingredients_id, null: false, default: 4
      t.integer :veganity_inquiries_id, null: false, default: 4
      t.integer :veganity_comments_id, null: false, default: 4
      t.integer :veganity_source_id, null: false, default: 4
      t.integer :veganity_id, null: false, default: 4
      t.string :source
      t.integer :integrity
      t.integer :user_id, null: false
      t.integer :up_user_id
      t.text :ingredients
      t.text :traces
      t.text :contains

      t.timestamps
    end
    add_attachment :products, :image
  end
end
