class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.text :website_url
      t.text :about_me
      t.attachment :logo
      
      t.timestamps
    end
  end
end
