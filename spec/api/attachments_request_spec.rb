require 'rails_helper'

RSpec.describe API::V1::AttachmentsController do
  let (:attach) { create(:attachment_valid_size) }
  let (:attach_stubbed) { build(:attachment) }

  subject { response }

  describe 'GET #index' do
    context 'common case' do
      before { make_request :get, api_comment_attachments_path(attach.comment_id) }

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
      it { expect(attach.id).to eq(parse_for_id(response).first) }
    end

    context 'when a wrong format is requested' do
      before { make_request :get, api_comment_attachments_path(attach.comment_id), mime_accept: Mime::XML }
 
      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end

    after { delete_dummy_file }
  end

  describe 'GET #show' do
    context 'common case' do
      before { make_request :get, api_attachment_path(attach.id) }

      it { is_expected.to have_http_status(:ok).and have_content_type(:png) }
    end

    context 'when a resource is not found' do
      before { make_request :get, api_attachment_path(attach.id + 1) }

      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before { make_request :get, api_attachment_path(attach.id), mime_accept: Mime::XML }
 
      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end

    after { delete_dummy_file }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before do
        make_request :post, api_comment_attachments_path(attach_stubbed.comment_id), {'data'=> json_api(:attachment_upload_valid)}
      end

      it { is_expected.to have_http_status(201).and have_content_type(:json) }
    end

    context 'with invalid size' do
      before do
        make_request :post, api_comment_attachments_path(attach_stubbed.comment_id), {'data'=> json_api(:attachment_upload_invalid)}
      end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before do
        @count = Attachment.count
        make_request :post, api_comment_attachments_path(attach_stubbed.comment_id), {'data'=> json_api(:attachment_upload_valid)}, mime_accept: Mime::XML
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(Attachment.count).to eq(@count) }
    end

    after { delete_dummy_file }
  end

  describe 'DELETE #destroy' do
    context 'with a valid id' do
      before { make_request :delete, api_attachment_path(attach.id) }

      it { is_expected.to have_http_status(204) }
      it { refute Attachment.find_by(id: attach.id) }
    end

    context 'when a resourse is not found' do
      before { make_request :delete, api_attachment_path(attach.id + 1) }
 
      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before { make_request :delete, api_attachment_path(attach.id), mime_accept: Mime::XML }
 
      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { assert Attachment.find_by(id: attach.id) }
    end

    after { delete_dummy_file }
  end
end
