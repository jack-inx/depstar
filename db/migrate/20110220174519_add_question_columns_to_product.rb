class AddQuestionColumnsToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :question_1_is_enabled, :boolean
    add_column :products, :question_1_name, :string
    add_column :products, :question_1_option_1_multiplier, :float
    add_column :products, :question_1_option_2_multiplier, :float

    add_column :products, :question_2_is_enabled, :boolean
    add_column :products, :question_2_name, :string
    add_column :products, :question_2_option_1_multiplier, :float
    add_column :products, :question_2_option_2_multiplier, :float

    add_column :products, :question_3_is_enabled, :boolean
    add_column :products, :question_3_name, :string
    add_column :products, :question_3_option_1_multiplier, :float
    add_column :products, :question_3_option_2_multiplier, :float
    add_column :products, :question_3_option_3_multiplier, :float
    add_column :products, :question_3_option_4_multiplier, :float

    add_column :products, :question_4_is_enabled, :boolean
    add_column :products, :question_4_name, :string
  end

  def self.down
    remove_column :products, :question_1_is_enabled
    remove_column :products, :question_1_name
    remove_column :products, :question_1_option_1_multiplier
    remove_column :products, :question_1_option_2_multiplier

    remove_column :products, :question_2_is_enabled
    remove_column :products, :question_2_name
    remove_column :products, :question_2_option_1_multiplier
    remove_column :products, :question_2_option_2_multiplier

    remove_column :products, :question_3_is_enabled, :boolean
    remove_column :products, :question_3_name, :string
    remove_column :products, :question_3_option_1_multiplier
    remove_column :products, :question_3_option_2_multiplier
    remove_column :products, :question_3_option_3_multiplier
    remove_column :products, :question_3_option_4_multiplier

    remove_column :products, :question_4_is_enabled
    remove_column :products, :question_4_name  
  end
end
