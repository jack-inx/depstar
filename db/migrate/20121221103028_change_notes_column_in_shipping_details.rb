class ChangeNotesColumnInShippingDetails < ActiveRecord::Migration
  def up
    change_column :shipping_details, :notes, :text
  end

  def down
    change_column :shipping_details, :notes, :string
  end
end
