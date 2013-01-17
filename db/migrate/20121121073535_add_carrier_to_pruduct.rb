class AddCarrierToPruduct < ActiveRecord::Migration
def self.up
    add_column :products, :carrier_id, :string
  end

  def self.down
    remove_column :products, :carrier_id
  end
end
