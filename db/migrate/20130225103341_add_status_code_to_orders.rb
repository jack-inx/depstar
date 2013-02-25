class AddStatusCodeToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :status_code, :integer, :default => 0
  end

  def self.down
    remove_column :orders, :status_code
  end
end
