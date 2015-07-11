json.array!(@attachments) do |attachment|
  json.extract! attachment, :id, :filename, :mime_type, :data
  json.url attachment_url(attachment, format: :json)
end
