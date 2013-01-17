class AddStatusCodeToShippingDetails < ActiveRecord::Migration
  def self.up
    add_column :shipping_details, :status_code, :integer, :default => 0
  end

  def self.down
    remove_column :shipping_details, :status_code
  end
end
