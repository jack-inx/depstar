class AddColumnProductTitleToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :product_title, :string
  end
end
