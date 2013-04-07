class RemoveCompletedDateFromTasks < ActiveRecord::Migration
  def up
  	remove_column :tasks, :completed_date
  end

  def down
  	add_column :tasks, :completed_date, :datetime
  end
end
