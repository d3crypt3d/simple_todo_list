class ProjectSerializer < BaseSerializer
  Project.attribute_names.each { |attr| attribute attr.to_sym }

  has_many :tasks

  #def links
  #  {
  #    self: '//foo',
  #    related: '//bar'
  #  }
  #end
  #link :self, '//foo'
end
