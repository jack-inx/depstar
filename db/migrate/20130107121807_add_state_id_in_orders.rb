class AddStateIdInOrders < ActiveRecord::Migration
 def change
    add_column :orders, :state_id, :integer
  end
end
