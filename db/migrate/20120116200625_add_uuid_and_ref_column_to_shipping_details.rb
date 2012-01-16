class AddUuidAndRefColumnToShippingDetails < ActiveRecord::Migration
  def self.up
    add_column :shipping_details, :uuid, :string
    add_column :shipping_details, :referer, :string
  end

  def self.down
    remove_column :shipping_details, :referer
    remove_column :shipping_details, :uuid
  end
end
