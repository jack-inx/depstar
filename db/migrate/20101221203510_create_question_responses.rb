class CreateQuestionResponses < ActiveRecord::Migration
  def self.up
    create_table :question_responses do |t|
      t.integer :product_id
      t.string :question_1
      t.string :question_2
      t.string :question_3
      t.string :question_4

      t.timestamps
    end
  end

  def self.down
    drop_table :question_responses
  end
end
