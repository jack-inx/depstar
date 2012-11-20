class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :name
      t.attachment :image
      t.timestamps
    end
  end
end
