class Task < ActiveRecord::Base
    belongs_to :project
    has_many :comments, dependent: :destroy

    validates_presence_of :content, :priority, :deadline, :project_id
    validates :priority, :project_id, numericality: { only_integer: true, greater_than: 0 }
    validates_uniqueness_of :priority, scope: :project_id 

    after_initialize :defaults

    private
    def defaults
        self.isdone ||= false
    end
end
