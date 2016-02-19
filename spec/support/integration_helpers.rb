module IntegrationHelpers
  # get api_projects_path(format: :json) also results in a proper
  # response, however, sending the Accept header is more semantically 
  # correct (according to RFC 2616).
  def make_request(method, path, data={}, mime_accept: Mime::JSON)
    headers_to_send = {}
    # Token headers are also vitaly important: 
    # merge them into one hash
    headers_to_send.merge!(token_headers) if token_headers
    headers_to_send['HTTP_ACCEPT']= mime_accept 
    self.send(method, path, data, headers_to_send)
  end
end
