class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name, null: false
      t.integer :feature_id, null: false
      t.string :image
      t.string :source
      t.integer :user_id, null: false
      t.text :description

      t.timestamps
    end
    add_attachment :labels, :image
  end
end
