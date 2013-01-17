class AddPriceFieldsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :used_price, :integer
    add_column :products, :broken_price, :integer
  end
end
