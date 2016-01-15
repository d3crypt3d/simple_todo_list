class CommentSerializer < BaseSerializer
  Comment.attribute_names.each { |attr| attribute attr.to_sym }

  has_many :attachments
end
