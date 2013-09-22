class CreateClassnameSynonyms < ActiveRecord::Migration
  def change
    create_table :classname_synonyms do |t|
      t.integer :classname_id, null: false
      t.string :sg, null: false
      t.string :pl, null: false
      
      t.timestamps
    end
  end
end
