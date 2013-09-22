class CreateClassnames < ActiveRecord::Migration
  def change
    create_table :classnames do |t|
      t.string :sg, null: false
      t.string :pl, null: false
      t.string :abbr, null: false

      t.timestamps
    end
  end
end
