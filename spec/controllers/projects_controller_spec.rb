require 'rails_helper'

RSpec.describe API::ProjectsController do

    describe "GET #index" do
        let(:project_list) { create_list(:project, 2) }

        subject { response }

        context "common case" do
           before { make_request :get, :index }  

           it { is_expected.to have_http_status(:ok).and have_content_type(:json) } 
           # strange, following doesn't work if project_list and
           # Project.first(2) are swapped
           it { expect(project_list).to match_array(Project.first(2)) }
        end 

        context "when requested a wrong content" do
           before { make_request :get, :index, accept: Mime::XML }
           it { is_expected.to have_http_status(406).and have_content_type(:json) }
        end
    end

    describe "GET #show" do
        let(:proj) { create(:project) }

        subject { response }

        context "common case" do
            before { make_request :get, :show, id: proj } 

            it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
        end

        context "when a resource is not found" do
            before { make_request :get, :show, id: proj.id + 1 }

            it { is_expected.to have_http_status(404).and have_content_type(:json) } 
        end

        context "when requested a wrong content" do
             before { make_request :get, :show, id: proj, accept: Mime::XML } 

             it { is_expected.to have_http_status(406).and have_content_type(:json) }
        end
    end

    
    describe "POST #create" do
        subject { response }

        context "with valid attributes" do
            before do
                make_request :post, :create,
                    project: attributes_for(:project)
            end 

            it { is_expected.to have_http_status(201).and have_content_type(:json) }
        end

        context "with invalid attributes" do
            before do
                make_request :post, :create,
                    project: attributes_for(:invalid_project) 
            end

            it { is_expected.to have_http_status(422).and have_content_type(:json) }
        end
        
        context "when requested a wrong content" do
           before do
              @count = Project.count 
              make_request :post, :create,
                            project: attributes_for(:project), accept: Mime::XML
           end

           it { is_expected.to have_http_status(406).and have_content_type(:json) }
           # we are going to verify that the project data will not be saved
           # in the DB; the only way to do that is checking the count; 
           # expect { make_request }.not_to change(Project, :count) will be
           # an ugly contruct, since we also need to verify response params,
           # hence we need make_request been performed only once 
           it { expect(Project.count).to eq(@count) }
        end
    end

    describe "PATCH #update" do
        # let's symbol generates the resource once be called
        # (as many, as many times we call it during transactional fixture)
        let(:proj) { create(:project) }

        subject { response }

        context "with valid attributes" do
            before do
                make_request :patch, :update,
                    # generating another random name can be confusing,
                    # since we're going to check whether the original  
                    # name has been changed
                    id: proj, project: {name: 'edited_name'} 
            end

            it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
            # assigns takes a variable, instantiated by the controller method,
            # with updated data; 
            it { expect(assigns(:project).name).to eq('edited_name') }
        end

        context "with invalid attributes" do
            before do
                make_request :patch, :update,
                    id: proj, project: attributes_for(:invalid_project)
            end 

            it { is_expected.to have_http_status(422).and have_content_type(:json) }
        end

        context "when requested a wrong content" do
            before do
                make_request :patch, :update, id: proj,
                              project: {name: 'another_name'}, accept: Mime::XML
            end

            it { is_expected.to have_http_status(406).and have_content_type(:json) }
            # this time project's data should not be updated
            it { expect(assigns(:project).name).not_to eq('another_name') }
        end
    end

    describe "DELETE #destroy" do
        let(:proj) { create(:project) }

        subject { response }

        context "with valid id" do

            before { make_request :delete, :destroy, id: proj }

            it { is_expected.to have_http_status(204) }
            it { expect(Project.exists? proj).to be_falsey }
        end

        context "when a resourse is not found" do

            before { make_request :delete, :destroy, id: proj.id + 1 }

            it { is_expected.to have_http_status(404).and have_content_type(:json) }
        end

        context "when requested a wrong content" do

            before { make_request :delete, :destroy, id: proj, accept: Mime::XML }

            it { is_expected.to have_http_status(406).and have_content_type(:json) }
            # this time the resource should not be deleted
            it { expect(Project.exists? proj).to be_truthy }
        end
    end
end