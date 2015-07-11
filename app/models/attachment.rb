class Attachment < ActiveRecord::Base
    belongs_to :comment

    validates :filename, presence: true
end
