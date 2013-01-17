class RenameCategoryIdColumnOnQuestionOptions < ActiveRecord::Migration
  def self.up
    rename_column :question_options, :category_id, :product_id
  end

  def self.down
    rename_column :question_options, :product_id, :category_id
  end
end
