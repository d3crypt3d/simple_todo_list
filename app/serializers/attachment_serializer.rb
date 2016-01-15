class AttachmentSerializer < BaseSerializer
  attribute :filename
  attribute :mime_type
  attribute :created_at
  attribute :updated_at

  has_one :comment
end
