class ChangeDatatypeForOrdersPhoneNumber < ActiveRecord::Migration
  def up
    change_column :orders, :phone_number, :string
  end

  def down
    change_column :orders, :phone_number, :integer
  end
end
