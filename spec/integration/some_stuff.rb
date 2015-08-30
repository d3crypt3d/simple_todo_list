require 'rails_helper'

RSpec.describe API::ProjectsController do

    describe "POST #create" do
        subject {response}

        context "with valid attributes" do
            before do
                host! "api.simple-todo-list.net"
                post '/projects',
                    {project:{name:'lorem'}}.to_json,
                    { 'Accept' => 'application/json',
                      'Content-Type' => 'application/json' } 
            end

            it { is_expected.to have_http_status(201).and have_content_type(Mime::JSON) }
        end
    end
end
