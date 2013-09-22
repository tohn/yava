class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :provider_id, null: false
      t.string :uid, null: false
      t.string :name, null: false
      t.string :nickname, null: false
      t.string :email, null: false
      t.timestamp :lastlogin, null: false
      t.timestamp :lastaction, null: false
      t.integer :permission_id, null: false, default: 0
      t.integer :points, null: false, default: 0
      t.boolean :email_verified, null: false, default: false
      t.boolean :anonymize_name, null: false, default: false
      t.boolean :first_mail, null: false, default: false
      
      t.timestamps
      
      t.index :provider_id
      t.index :uid
    end
  end
end
