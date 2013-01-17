class AddCheckColumnsToShippingDetails < ActiveRecord::Migration
  def self.up
    add_column :shipping_details, :check_payment_name, :string
    add_column :shipping_details, :check_payment_address1, :string
    add_column :shipping_details, :check_payment_address2, :string
    add_column :shipping_details, :check_payment_city, :string
    add_column :shipping_details, :check_payment_state, :string
    add_column :shipping_details, :check_payment_zip, :string        
  end

  def self.down
    remove_colum :shipping_details, :check_payment_name
    remove_colum :shipping_details, :check_payment_address1
    remove_colum :shipping_details, :check_payment_address2
    remove_colum :shipping_details, :check_payment_city
    remove_colum :shipping_details, :check_payment_state
    remove_colum :shipping_details, :check_payment_zip
  end
end
