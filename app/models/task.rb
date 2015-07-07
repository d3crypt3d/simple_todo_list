class Task < ActiveRecord::Base
    attr_accessible :name, :task_id
    belongs_to :project
end
