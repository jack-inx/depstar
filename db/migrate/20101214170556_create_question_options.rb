class CreateQuestionOptions < ActiveRecord::Migration
  def self.up
    create_table :question_options do |t|
      t.integer :category_id
      t.string :name
      t.float :multipler

      t.timestamps
    end
  end

  def self.down
    drop_table :question_options
  end
end
