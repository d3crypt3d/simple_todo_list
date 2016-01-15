require 'rails_helper'

RSpec.describe API::V1::CommentsController do
  describe 'GET #index' do
    let(:task_comment_list) { create(:task_with_comments) }

    subject { response }

    context 'commen case' do
      before { make_request :get, :index, task_id: task_comment_list.id }

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
      it { expect(task_comment_list.comments).to match_array(Comment.first(2)) }
    end

    context 'when a wrong format is requested' do
      before { make_request :get, :index, task_id: task_comment_list.id, accept: Mime::XML }

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end
  end

  describe 'GET #show' do
    let(:task_comment) { create(:comment) }

    subject { response }

    context 'common case' do
      before { make_request :get, :show, id: task_comment.id }

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
    end
    
    context 'when a resource is not found' do
      before { make_request :get, :show, {id: task_comment.id + 1} }

      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end
    
    context 'when a wrong format is requested' do
      before { make_request :get, :show, id: task_comment.id, accept: Mime::XML } 

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end
  end

  describe 'POST #create' do
    let(:comment_task) { create(:task) }

    subject { response }

    context 'with valid attributes' do
      before do
        make_request :post, :create, task_id: comment_task.id, data: json_api(:comment)
      end

      it {is_expected.to have_http_status(201).and have_content_type(:json) }
    end

    context 'with invalid attributes' do
      before do
        make_request :post, :create, task_id: comment_task.id, data: json_api(:invalid_comment) 
      end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end
    
    context 'when a wrong format is requested' do
      before do
        @count = Comment.count
        make_request :post, :create, task_id: comment_task.id,
                     accept: Mime::XML, data: json_api(:comment)
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(Comment.count).to eq(@count) }
    end
  end

  describe 'DELETE #destroy' do
    let(:task_comment) { create(:comment) }

    subject { response }

    context 'with a valid id' do
      before { make_request :delete, :destroy, id: task_comment.id }

      it { is_expected.to have_http_status(204) }
      it { expect(Comment.exists? task_comment).to be_falsey }
    end
    
    context 'when a resourse is not found' do
      before { make_request :delete, :destroy, {id: task_comment.id + 1} }
      
      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before { make_request :delete, :destroy, id: task_comment.id, accept: Mime::XML }

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(Comment.exists? task_comment).to be_truthy }
    end
  end
end
