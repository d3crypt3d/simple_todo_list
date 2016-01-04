module ControllerHelpers
# When it comes to controller specs, methods for simulation
# HTTP requests belong to ActionController::TestCase::Behavior;
# although having same names with Rack::Test::Methods ones, they
# act differently: only actions within the controller
# scope can be executed and impossible to set HTTP headers  
# as a method's parameter (our wrapper helps to deal
# with that). 
# 
# Although it's possible to pass the raw POST body directly
# as an additional argument at the beginning of the list
# (2nd argument in the example below), it doesn't parse the
# supplied data, so we stil need to send the params
# as a Hash (3d argument in the example below),
# 
#   form = { post: {title: 'A post title', body: 'Some text'} }
#   post :create, form.to_json, form
#   
# because PARSING the JSON data is NOT supported (Rails team,
# claims it will be supported in the 5th version)

  def make_request(method, action, accept: Mime::JSON, **data)
    request.env['HTTP_ACCEPT'] = accept.to_s 
    self.send(method, action, data)
  end
end
