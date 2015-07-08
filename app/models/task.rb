class Task < ActiveRecord::Base
    belongs_to :project

    validates :content, :priority, :deadline, :project_id, presence: true
    validates :priority, :project_id, numericality: { only_integer: true, greater_than: 0 }
    validates :priority, uniqueness: { scope: :project_id } 

    after_initialize :defaults

    def defaults
        self.isdone ||= false
    end
end
