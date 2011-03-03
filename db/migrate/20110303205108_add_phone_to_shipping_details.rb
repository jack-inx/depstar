class AddPhoneToShippingDetails < ActiveRecord::Migration
  def self.up
    add_column :shipping_details, :phone, :string
  end

  def self.down
    remove_column :shipping_details, :phone
  end
end
