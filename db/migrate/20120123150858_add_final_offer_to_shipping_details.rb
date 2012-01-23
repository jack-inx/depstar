class AddFinalOfferToShippingDetails < ActiveRecord::Migration
  def self.up
    add_column :shipping_details, :final_offer, :integer
  end

  def self.down
    remove_column :shipping_details, :final_offer
  end
end
