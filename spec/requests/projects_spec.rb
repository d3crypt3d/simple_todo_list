require 'rails_helper'

RSpec.describe "Projects", :type => :request do

    before(:all) { host! "api.simple-todo-list.net" }

    describe "GET /projects" do
        before do
            @project_list = create_list(:project, 2)
            get api_projects_path, { Accept: Mime::JSON }
            @response_list = json(response.body)[:projects]
        end
        it "should return proper collection" do
            expect(response).to have_http_status(200).and have_content_type(Mime::JSON)
            expect(@response_list.size).to eq(2) 
        end
        it "should have same names" do
           #since we've created several projects we are going to compare
           #their names with ones inside the response collection; no need
           #to compare all the properties - too much headache with convertion
           #the project list into the proper hash one (turn the model into,
           #the hash, symbolize keys, convert datetime properties into another
           #format), moreover sequence and name matches are only things
           #important to us 
           project_name_list = @project_list.map {|obj| obj.name}          #array of objects
           response_name_list = @response_list.map { |hash| hash[:name] }  #array of hashes 
           expect(project_name_list).to match_array(response_name_list)
        end 
    end

end
