class AddColumnIsAffiliateAdminAndUserId < ActiveRecord::Migration
  def up
    add_column :users, :is_affiliate_admin, :boolean, :default => true 
    add_column :users, :user_id, :integer, :default => nil
  end

  def down
    remove_column :users, :is_affiliate_admin 
    remove_column :users, :user_id
  end
end
