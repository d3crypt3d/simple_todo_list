class TaskSerializer < BaseSerializer
  Task.attribute_names.each { |attr| attribute attr.to_sym }

  has_many :comments
end
