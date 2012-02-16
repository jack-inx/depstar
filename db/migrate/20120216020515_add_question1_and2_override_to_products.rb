class AddQuestion1And2OverrideToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :question_1_option_1_price, :integer
    add_column :products, :question_1_option_2_price, :integer
    add_column :products, :question_2_option_1_price, :integer
    add_column :products, :question_2_option_2_price, :integer
  end

  def self.down
    remove_column :products, :question_1_option_1_price
    remove_column :products, :question_1_option_2_price
    remove_column :products, :question_2_option_1_price
    remove_column :products, :question_2_option_2_price
  end
end
