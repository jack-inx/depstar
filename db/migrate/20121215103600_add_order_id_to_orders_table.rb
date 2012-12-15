class AddOrderIdToOrdersTable < ActiveRecord::Migration
  def change
    add_column :orders, :order_id, :string
    add_column :orders, :notes, :text
    add_column :order_product_price_types, :price, :integer
  end
end
