class RenameColumnValueOnProducts < ActiveRecord::Migration
  def self.up
    rename_column :products, :value, :price
  end

  def self.down
    rename_column :products, :price, :value
  end
end
