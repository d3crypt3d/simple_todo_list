class AddTasksToProject < ActiveRecord::Migration
  def change
    add_reference :projects, :task, index: true
  end
end
