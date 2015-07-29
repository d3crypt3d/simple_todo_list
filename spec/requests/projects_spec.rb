require 'rails_helper'

RSpec.describe "Projects", :type => :request do
    before(:all) { host! "api.simple-todo-list.net" }

    describe "GET /projects" do
        before do
        end
        it "should return proper collection" do
            get api_projects_path, { Accept: Mime::JSON }
            expect(response).to have_http_status(200).and have_content_type(Mime::JSON)
        end
    end

end
