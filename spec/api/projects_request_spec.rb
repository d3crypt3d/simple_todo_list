require 'rails_helper'

RSpec.describe API::V1::ProjectsController do
  let(:proj) { create(:project) }
  let(:project_list) { create_list(:project, 2) }

  subject { response }

  describe "GET #index" do
    context "common case" do
      before do
        project_list
        make_request :get, api_projects_path
      end 

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) } 

      it 'returns proper ids' do
        expect(project_list.map(&:id)).to eq(parse_for_id(response))
      end
    end 

    context "when requested a wrong content" do
      before { make_request :get, api_projects_path, mime_accept: Mime::XML }
      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end
  end

  describe "GET #show" do
    context "common case" do
      before { make_request :get, api_project_path(proj.id) } 

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
    end

    context "when a resource is not found" do
      before { make_request :get, api_project_path(proj.id + 1) } 

      it { is_expected.to have_http_status(404).and have_content_type(:json) } 
    end

    context "when requested a wrong content" do
      before { make_request :get, api_project_path(proj.id), mime_accept: Mime::XML } 

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end
  end

  
  describe "POST #create" do
    context "with valid attributes" do
      before do
        # data parametrized key will result as a root node
        # as required in JSON API spec
        make_request :post, api_projects_path, {'data'=> json_api(:project)}
      end 

      it { is_expected.to have_http_status(201).and have_content_type(:json) }
    end

    context "with invalid attributes" do
      before do
        make_request :post, api_projects_path, {'data'=> json_api(:invalid_project)}
      end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end
    
    context "when requested a wrong content" do
      before do
        @count = Project.count 
        make_request :post, api_projects_path, {'data'=> json_api(:project)}, mime_accept: Mime::XML
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      # we are going to verify that the project data will not be saved
      # in the DB; the only way to do that is checking the count; 
      # expect { make_request }.not_to change(Project, :count) will be
      # an ugly contruct, since we also need to verify response params,
      # hence we need make_request to be performed once only
      it { expect(Project.count).to eq(@count) }
    end
  end

  describe "PATCH #update" do
    # once be called let's symbol generates the resource 
    # (as many, as many times we call it during transactional fixture)
    context "with valid attributes" do
      before do
        # generating another random name can be confusing,
        # since we're going to check whether the original 
        # name has been changed; 
        # id: is a mandatory parameter - it will result as
        # a route id (it will not be merged with JSON API
        # object - last is binded to data: key)  
        make_request :patch, api_project_path(proj.id), {'data'=> json_api(:project, name: 'edited_name')} 
      end

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
      # assigns takes a variable, instantiated by the controller method, with updated data; 
      it { expect(assigns(:project).name).to eq('edited_name') }
    end

    context "with invalid attributes" do
      before do
        make_request :patch, api_project_path(proj.id), {'data'=> json_api(:invalid_project)}
      end 

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end

    context "when requested a wrong content" do
      before do
        make_request :patch, api_project_path(proj.id), {'data'=> json_api(:project, name: 'another_name')}, mime_accept: Mime::XML
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      # this time project's data should not be updated
      it { expect(assigns(:project).name).not_to eq('another_name') }
    end
  end

  describe "DELETE #destroy", debug: true do
    context "with valid id" do
      before { make_request :delete, api_project_path(proj.id) }

      it { is_expected.to have_http_status(204) }
      it { refute Project.find_by(id: proj.id) }
    end

    context "when a resourse is not found" do
      before { make_request :delete, api_project_path(proj.id + 1) }

      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end

    context "when requested a wrong content" do
      before { make_request :delete, api_project_path(proj.id), mime_accept: Mime::XML }

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      # this time the resource should not be deleted
      it { assert Project.find_by(id: proj.id) }
    end
  end
end
