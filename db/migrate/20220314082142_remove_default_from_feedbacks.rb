class RemoveDefaultFromFeedbacks < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:feedbacks, :priority, nil)
  end
end
