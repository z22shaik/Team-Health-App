class AddQuestionsToFeedback < ActiveRecord::Migration[6.1]
  def change
    add_column :feedbacks, :contribution, :integer, null: false
    add_column :feedbacks, :attendance, :integer, null: false
    add_column :feedbacks, :respect, :integer, null: false
    add_column :feedbacks, :knowledge, :integer, null: false
  end
end
