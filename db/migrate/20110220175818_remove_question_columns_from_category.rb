class RemoveQuestionColumnsFromCategory < ActiveRecord::Migration
  def self.up
    remove_column :categories, :question_1_is_enabled
    remove_column :categories, :question_1_name
    remove_column :categories, :question_1_option_1_multiplier
    remove_column :categories, :question_1_option_2_multiplier

    remove_column :categories, :question_2_is_enabled
    remove_column :categories, :question_2_name
    remove_column :categories, :question_2_option_1_multiplier
    remove_column :categories, :question_2_option_2_multiplier

    #remove_column :categories, :question_3_is_enabled, :boolean
    #remove_column :categories, :question_3_name, :string
    #remove_column :categories, :question_3_option_1_multiplier
    #remove_column :categories, :question_3_option_2_multiplier
    #remove_column :categories, :question_3_option_3_multiplier
    #remove_column :categories, :question_3_option_4_multiplier

    #remove_column :categories, :question_4_is_enabled
    #remove_column :categories, :question_4_name
  end

  def self.down
    add_column :categories, :question_1_is_enabled, :boolean
    add_column :categories, :question_1_name, :string
    add_column :categories, :question_1_option_1_multiplier, :float
    add_column :categories, :question_1_option_2_multiplier, :float

    add_column :categories, :question_2_is_enabled, :boolean
    add_column :categories, :question_2_name, :string
    add_column :categories, :question_2_option_1_multiplier, :float
    add_column :categories, :question_2_option_2_multiplier, :float

    #add_column :categories, :question_3_is_enabled, :boolean
    #add_column :categories, :question_3_name, :string
    #add_column :categories, :question_3_option_1_multiplier, :float
    #add_column :categories, :question_3_option_2_multiplier, :float
    #add_column :categories, :question_3_option_3_multiplier, :float
    #add_column :categories, :question_3_option_4_multiplier, :float

    #add_column :categories, :question_4_is_enabled, :boolean
    #add_column :categories, :question_4_name, :string
  end
end
