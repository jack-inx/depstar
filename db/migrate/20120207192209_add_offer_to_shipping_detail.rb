class AddOfferToShippingDetail < ActiveRecord::Migration
  def self.up
    add_column :shipping_details, :offer, :integer
  end

  def self.down
    remove_column :shipping_details, :offer
  end
end
