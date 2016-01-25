require 'rails_helper'

RSpec.describe API::V1::CommentsController do
  describe 'GET #index' do
    let(:task_comment_list) { create(:task_with_comments) }

    subject { response }

    context 'common case' do
      before { get api_task_comments_path(task_comment_list.id), {}, {Accept: Mime::JSON} }

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
      it { expect(task_comment_list.comments.ids).to eq(parse_for_id(response)) }
    end

    context 'when a wrong format is requested' do
      before { get api_task_comments_path(task_comment_list.id), {}, {Accept: Mime::XML} }

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end
  end

  describe 'GET #show' do
    let(:task_comment) { create(:comment) }

    subject { response }

    context 'common case' do
      before { get api_comment_path(task_comment.id), {}, {Accept: Mime::JSON} }

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
    end
    
    context 'when a resource is not found' do
      before { get api_comment_path(task_comment.id + 1), {}, {Accept: Mime::JSON} }

      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end
    
    context 'when a wrong format is requested' do
      before { get api_comment_path(task_comment.id), {}, {Accept: Mime::XML} } 

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end
  end

  describe 'POST #create' do
    let(:comment_task) { create(:task) }

    subject { response }

    context 'with valid attributes' do
      before do
        post api_task_comments_path(comment_task.id), {data: json_api(:comment)}, {Accept: Mime::JSON}
      end

      it {is_expected.to have_http_status(201).and have_content_type(:json) }
    end

    context 'with invalid attributes' do
      before do
        post api_task_comments_path(comment_task.id), {data: json_api(:invalid_comment)}, {Accept: Mime::JSON}
 
      end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end
    
    context 'when a wrong format is requested' do
      before do
        @count = Comment.count
        post api_task_comments_path(comment_task.id), {data: json_api(:comment)}, {Accept: Mime::XML}
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(Comment.count).to eq(@count) }
    end
  end

  describe 'DELETE #destroy' do
    let(:task_comment) { create(:comment) }

    subject { response }

    context 'with a valid id' do
      before { delete api_comment_path(task_comment.id), {}, {Accept: Mime::JSON} }

      it { is_expected.to have_http_status(204) }
      it { expect(Comment.exists? task_comment).to be_falsey }
    end
    
    context 'when a resourse is not found' do
      before { delete api_comment_path(task_comment.id + 1), {}, {Accept: Mime::JSON} }
      
      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before { delete api_comment_path(task_comment.id), {}, {Accept: Mime::XML} }

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(Comment.exists? task_comment).to be_truthy }
    end
  end
end
