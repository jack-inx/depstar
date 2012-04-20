class DevicesChangeColumnDefaultOnStatusCode < ActiveRecord::Migration
  def up
    # Make sure no null value exist
    # 'status_code NOT NULL' does not work correctly
    Device.update_all('status_code = 0', 'status_code NOT IN (0,1,2,3,4,5,6,7,8)')

    # Change the column to not allow null
    change_column :devices, :status_code, :integer, :default => 0
    
    change_column :devices, :status_code, :integer, :null => false
  end

  def down
    change_column :devices, :status_code, :integer, :null => true, :default => nil
  end
end
