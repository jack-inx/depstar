class AddSerialToShippingDetails < ActiveRecord::Migration
  def self.up
    add_column :shipping_details, :serial, :string
  end

  def self.down
    remove_column :shipping_details, :serial
  end
end
