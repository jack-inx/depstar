class RenameColumnMultiplerOnQuestionOptions < ActiveRecord::Migration
  def self.up
    rename_column :question_options, :multipler, :multiplier
  end

  def self.down
    rename_column :question_options, :multiplier, :multipler
  end
end
