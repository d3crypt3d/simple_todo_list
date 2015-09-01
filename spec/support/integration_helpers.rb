module IntegrationHelpers
    # get api_projects_path(format: :json) also results in a proper
    # response, however, sending the Accept header is more semantically 
    # correct (according to RFC 2616).
    def make_request(method, action, data=nil, accept='application/json')
        accept['Content-Type'] = 'application/json' if method == :get
        self.send(method, action, data, accept)
    end
end
