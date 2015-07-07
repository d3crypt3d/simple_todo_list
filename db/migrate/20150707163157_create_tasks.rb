class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :content
      t.integer :priority
      t.datetime :deadline
      t.boolean :isdone

      t.timestamps
    end
  end
end
