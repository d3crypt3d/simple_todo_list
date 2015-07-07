class Task < ActiveRecord::Base
    attr_accessible :name, :project_id
    belongs_to :project
end
