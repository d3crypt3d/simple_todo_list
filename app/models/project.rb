class Project < ActiveRecord::Base
    has_many :tasks, dependent: :destroy

    validates_presence_of :name

    def find_unarchived(id)
        find_by!(id: id, archived: false)
    end

    def archive
        self.archived_at = Time.now
        self.save
    end
end
