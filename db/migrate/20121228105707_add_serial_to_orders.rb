class AddSerialToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :serial_no, :string
  end
end
