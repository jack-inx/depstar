class CreateJoinTableCarriersManufacturers < ActiveRecord::Migration
  def up
    create_table :carriers_manufacturers, :id => false do |t|
      t.integer :carrier_id
      t.integer :manufacturer_id
    end
  end

  def down
    drop_table :carriers_manufacturers
  end
end
