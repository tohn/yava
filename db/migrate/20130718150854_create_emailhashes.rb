class CreateEmailhashes < ActiveRecord::Migration
  def change
    create_table :emailhashes do |t|
      t.integer :user_id, null: false
      t.string :salt, null: false

      t.timestamps
    end
  end
end
