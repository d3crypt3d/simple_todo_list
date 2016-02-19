require 'rails_helper'

RSpec.describe API::V1::CommentsController do
  let(:task_comment_list) { create(:task_with_comments) }
  let(:task_comment) { create(:comment) }
  let(:comment_task) { create(:task) }

  subject { response }

  describe 'GET #index' do
    context 'common case' do
      before { make_request :get, api_task_comments_path(task_comment_list.id) }

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
      it { expect(task_comment_list.comments.ids).to eq(parse_for_id(response)) }
    end

    context 'when a wrong format is requested' do
      before do
        make_request :get, api_task_comments_path(task_comment_list.id), mime_accept: Mime::XML 
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end
  end

  describe 'GET #show' do
    context 'common case' do
      before { make_request :get, api_comment_path(task_comment.id) }

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
    end
    
    context 'when a resource is not found' do
      before { make_request :get, api_comment_path(task_comment.id + 1) }

      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end
    
    context 'when a wrong format is requested' do
      before { make_request :get, api_comment_path(task_comment.id), mime_accept: Mime::XML } 

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before do
        make_request :post, api_task_comments_path(comment_task.id), {'data'=> json_api(:comment)}
      end

      it {is_expected.to have_http_status(201).and have_content_type(:json) }
    end

    context 'with invalid attributes' do
      before do
        make_request :post, api_task_comments_path(comment_task.id), {'data'=> json_api(:invalid_comment)}
      end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end
    
    context 'when a wrong format is requested' do
      before do
        @count = Comment.count
        make_request :post, api_task_comments_path(comment_task.id), {'data'=> json_api(:comment)}, mime_accept: Mime::XML
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(Comment.count).to eq(@count) }
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid id' do
      before { make_request :delete, api_comment_path(task_comment.id) }

      it { is_expected.to have_http_status(204) }
      it { refute Comment.find_by(id: task_comment.id) }
    end
    
    context 'when a resourse is not found' do
      before { make_request :delete, api_comment_path(task_comment.id + 1) }
      
      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before { make_request :delete, api_comment_path(task_comment.id), mime_accept: Mime::XML }

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { assert Comment.find_by(id: task_comment.id) }
    end
  end
end
