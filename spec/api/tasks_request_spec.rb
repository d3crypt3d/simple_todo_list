require 'rails_helper'

RSpec.describe API::V1::TasksController do
  describe 'GET #index' do
    let(:project_task_list) { create(:project_with_tasks) }
    
    subject { response }

    context 'common case' do
      before do
        get api_project_tasks_path(project_task_list.id), {}, {Accept: Mime::JSON} 
      end

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
      it { expect(project_task_list.tasks.map(&:id)).to eq(parse_for_id(response)) }
    end

    context 'when a wrong format is requested' do
      before do
        get api_project_tasks_path(project_task_list.id), {}, {Accept: Mime::XML} 
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end
  end

  describe 'GET #show' do
    let(:project_task) { create(:task) }

    subject { response }

    context 'common case' do
      before { get api_task_path(project_task.id), {}, {Accept: Mime::JSON} }

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
    end

    context 'when a resource is not found' do
      before { get api_task_path(project_task.id + 1), {}, {Accept: Mime::JSON} }
      
      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before { get api_task_path(project_task.id), {}, {Accept: Mime::XML} } 

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end
  end
      
  describe 'POST #create' do
    let(:proj) { create(:project) }

    subject { response }

    context 'with valid attributes' do
      before do
        post api_project_tasks_path(proj.id), {data: json_api(:task)}, {Accept: Mime::JSON} 
      end
      
      it {is_expected.to have_http_status(201).and have_content_type(:json) }
    end

    context 'with invalid attributes' do
      before do
        post api_project_tasks_path(proj.id), {data: json_api(:invalid_task)}, {Accept: Mime::JSON} 
      end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end
    
    context 'when a wrong format is requested' do
      before do
        @count = Task.count
        post api_project_tasks_path(proj.id), {data: json_api(:task)}, {Accept: Mime::XML} 
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(Task.count).to eq(@count) }
    end
  end

  describe 'PATCH #update' do
    let(:project_task) { create(:task) } 
    
    subject { response }

    context 'with valid attributes' do
      before do
        patch api_task_path(project_task.id), {data: json_api(:task, content: 'updated')}, {Accept: Mime::JSON}
      end

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }

      it { expect(assigns(:task).content).to eq('updated') }
    end

    context 'with invalid attributes' do
      before do
        patch api_task_path(project_task.id), {data: json_api(:invalid_task)}, {Accept: Mime::JSON}
 
      end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end
    
    context 'when a wrong format is requested' do
      before do
        patch api_task_path(project_task.id), {data: json_api(:invalid_task, content: 'dont_update_me')}, {Accept: Mime::XML}
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(assigns(:task).content).not_to eq('dont_update_me') }
    end
  end
  
  describe 'DELETE #destroy' do
    let(:project_task) { create(:task) }

    subject { response }

    context 'with a valid id' do
      before { delete api_task_path(project_task.id), {}, {Accept: Mime::JSON} }

      it { is_expected.to have_http_status(204) }
      it { expect(Task.exists? project_task).to be_falsey }
    end

    context 'when a resourse is not found' do
      before { delete api_task_path(project_task.id + 1), {}, {Accept: Mime::JSON} }

      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before { delete api_task_path(project_task.id), {}, {Accept: Mime::XML} }

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(Task.exists? project_task).to be_truthy }
    end
  end
end
