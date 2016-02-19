require 'rails_helper'

RSpec.describe API::V1::TasksController do
  let(:proj) { create(:project) }
  let(:project_task) { create(:task) }
  let(:project_task_list) { create(:project_with_tasks) }

  subject { response }

  describe 'GET #index' do
    context 'common case' do
      before do
        make_request :get, api_project_tasks_path(project_task_list.id)
      end

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
      it { expect(project_task_list.tasks.map(&:id)).to eq(parse_for_id(response)) }
    end

    context 'when a wrong format is requested' do
      before do
        make_request :get, api_project_tasks_path(project_task_list.id), mime_accept: Mime::XML 
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end
  end

  describe 'GET #show' do
    context 'common case' do
      before { make_request :get, api_task_path(project_task.id) }

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
    end

    context 'when a resource is not found' do
      before { make_request :get, api_task_path(project_task.id + 1) }
      
      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before { make_request :get, api_task_path(project_task.id), mime_accept: Mime::XML }

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end
  end
      
  describe 'POST #create' do
    context 'with valid attributes' do
      before do
        make_request :post, api_project_tasks_path(proj.id), {'data'=> json_api(:task)} 
      end
      
      it { is_expected.to have_http_status(201).and have_content_type(:json) }
    end

    context 'with invalid attributes' do
      before do
        make_request :post, api_project_tasks_path(proj.id), {'data'=> json_api(:invalid_task)} end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end
    
    context 'when a wrong format is requested' do
      before do
        @count = Task.count
        make_request :post, api_project_tasks_path(proj.id), {'data'=> json_api(:task)}, mime_accept: Mime::XML 
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(Task.count).to eq(@count) }
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        make_request :patch, api_task_path(project_task.id), {'data'=> json_api(:task, content: 'updated')}
      end

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
      it { expect(assigns(:task).content).to eq('updated') }
    end

    context 'with invalid attributes' do
      before do
        make_request :patch, api_task_path(project_task.id), {'data'=> json_api(:invalid_task)} 
      end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end
    
    context 'when a wrong format is requested' do
      before do
        make_request :patch, api_task_path(project_task.id), {'data'=> json_api(:invalid_task, content: 'dont_update_me')}, mime_accept: Mime::XML 
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(assigns(:task).content).not_to eq('dont_update_me') }
    end
  end
  
  describe 'DELETE #destroy' do
    context 'with a valid id' do
      before { make_request :delete, api_task_path(project_task.id) }

      it { is_expected.to have_http_status(204) }
      it { refute Task.find_by(id: project_task.id) }
    end

    context 'when a resourse is not found' do
      before { make_request :delete, api_task_path(project_task.id + 1) }

      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before { make_request :delete, api_task_path(project_task.id), mime_accept: Mime::XML }

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { assert Task.find_by(id: project_task.id) }
    end
  end
end
