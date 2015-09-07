module ControllerHelpers
# in controller specs methods for HTTP requests simulation
# belong to ActionController::TestCase::Behavior; unlike
# Rack::Test::Methods ones, they behave differently, although
# have same names; only actions within the controller scope
# can be executed, impossible to set headers as a method's parameter 
    def make_request(method, action, accept=Mime::JSON, content='application/json', **data)
        request.env['HTTP_ACCEPT'] = accept.to_s 
        request.env['CONTENT_TYPE'] = content unless method == :get
        data[:format] = accept.symbol
        self.send(method, action, data)
    end
end
