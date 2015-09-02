require 'rails_helper'

RSpec.describe API::TasksController do
    describe 'GET #index' do
        let(:project_task_list) { create(:project_with_tasks) }
        
        subject { response }

        context 'common case' do
            before { make_request :get, :index, {project_id: project_task_list.id} }

            it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
            it { expect(project_task_list.tasks).to match_array(Task.first(2)) }
        end

        context 'when a wrong format is requested' do
            before { make_request :get, :index, Mime::XML, {project_id: project_task_list.id} }

            it { is_expected.to have_http_status(406).and have_content_type(:json) }
        end
    end

    describe 'GET #show' do
        let(:project_task) { create(:task) }

        subject { response }

        context 'common case' do
            before { make_request :get, :show, {id: project_task} }

            it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
        end

        context 'when a resource is not found' do
            before { make_request :get, :show, {id: project_task.id + 1} }
           
            it { is_expected.to have_http_status(404).and have_content_type(:json) }
        end

        context 'when a wrong format is requested' do
            before { make_request :get, :show, Mime::XML, {id: project_task} } 

            it { is_expected.to have_http_status(406).and have_content_type(:json) }
        end
    end
            
    describe 'POST #create' do
        let(:proj) { create(:project) }

        subject { response }

        context 'with valid attributes' do
            before do
                make_request :post, :create, 
                    {task: attributes_for(:task), project_id: proj}
            end
            
            it {is_expected.to have_http_status(201).and have_content_type(:json) }
        end

        context 'with invalid attributes' do
            before do
                make_request :post, :create, 
                    {task: attributes_for(:invalid_task), project_id: proj}
            end


            it { is_expected.to have_http_status(422).and have_content_type(:json) }
        end
        
        context 'when a wrong format is requested' do
            before do
                @count = Task.count
                make_request :post, :create, Mime::XML,
                    {task: attributes_for(:task), project_id: proj}
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
                make_request :patch, :update,
                    {id: project_task, task: {content: 'updated'}}
            end

            it { is_expected.to have_http_status(:ok).and have_content_type(:json) }

            it { expect(assigns(:task).content).to eq('updated') }
        end

        context 'with invalid attributes' do
            before do
                make_request :patch, :update,
                    {id: project_task, task: attributes_for(:invalid_task)}
            end

            it { is_expected.to have_http_status(422).and have_content_type(:json) }
        end
        
        context 'when a wrong format is requested',test: true do
            before do
                make_request :patch, :update, Mime::XML,
                    {id: project_task, task: {content: 'dont_update_me'}}
            end

            it { is_expected.to have_http_status(406).and have_content_type(:json) }
            #it { expect(assigns(:task).content).not_to eq('dont_update_me') }
        end
    end
    
    describe 'DELETE #destroy' do
        let(:project_task) { create(:task) }

        subject { response }

        context 'with a valid id' do
            before { make_request :delete, :destroy, {id: project_task} }

            it { is_expected.to have_http_status(204) }
            it { expect(Task.exists? project_task).to be_falsey }
        end

        context 'when a resourse is not found' do
            before { make_request :delete, :destroy, {id: project_task.id + 1} }

            it { is_expected.to have_http_status(404).and have_content_type(:json) }
        end

        context 'when a wrong format is requested' do
            before { make_request :delete, :destroy, Mime::XML, {id: project_task.id} }

            it { is_expected.to have_http_status(406).and have_content_type(:json) }
            it { expect(Task.exists? project_task).to be_truthy }
        end
    end
end
