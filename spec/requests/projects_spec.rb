require 'rails_helper'

RSpec.describe "Projects", :type => :request do
    before(:all) { host! "api.simple-todo-list.net" }

    describe "GET /projects" do
        before do
            #FactoryGirl.create(:project)
            create_list(:project, 2)
        end
        it "should return proper collection" do
            get api_projects_path, { Accept: Mime::JSON }
            expect(response).to have_http_status(200).and have_content_type(Mime::JSON)
            projects = json(response.body)[:projects]
            expect(projects.size).to eq(2) 
        end
    end

end
