require 'rails_helper'

RSpec.describe API::V1::AttachmentsController do
  describe 'GET #index' do
    let (:attach) { create(:attachment_valid_size) }

    subject { response }

    context 'common case' do
      before { get api_comment_attachments_path(attach.comment_id), {}, {Accept: Mime::JSON} }

      it { is_expected.to have_http_status(:ok).and have_content_type(:json) }
      it { expect(attach.id).to eq(parse_for_id(response).first) }
    end

    context 'when a wrong format is requested' do
      before { get api_comment_attachments_path(attach.comment_id), {}, {Accept: Mime::XML} }
 
      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end

    after { delete_dummy_file }
  end

  describe 'GET #show' do
    let (:attach) { create(:attachment_valid_size) }

    subject { response }

    context 'common case' do
      before { get api_attachment_path(attach.id), {}, {Accept: Mime::JSON} }

      it { is_expected.to have_http_status(:ok).and have_content_type(:png) }
    end

    context 'when a resource is not found' do
      before { get api_attachment_path(attach.id + 1), {}, {Accept: Mime::JSON} }

      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before { get api_attachment_path(attach.id), {}, {Accept: Mime::XML} }
 
      it { is_expected.to have_http_status(406).and have_content_type(:json) }
    end

    after { delete_dummy_file }
  end

  describe 'POST #create' do
    let (:attach) { build(:attachment) }

    subject { response }

    context 'with valid attributes' do
      before do
        post api_comment_attachments_path(attach.comment_id), {data: json_api(:attachment_upload_valid)}, {Accept: Mime::JSON}
      end

      it { is_expected.to have_http_status(201).and have_content_type(:json) }
    end

    context 'with invalid size' do
      before do
        post api_comment_attachments_path(attach.comment_id), {data: json_api(:attachment_upload_invalid)}, {Accept: Mime::JSON}
      end

      it { is_expected.to have_http_status(422).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before do
        @count = Attachment.count
        post api_comment_attachments_path(attach.comment_id), {data: json_api(:attachment_upload_valid)}, {Accept: Mime::XML}
      end

      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(Attachment.count).to eq(@count) }
    end

    after { delete_dummy_file }
  end

  describe 'DELETE #destroy' do
    let (:attach) { create(:attachment_valid_size) }

    subject { response }

    context 'with a valid id' do
      before { delete api_attachment_path(attach.id), {}, {Accept: Mime::JSON} }

      it { is_expected.to have_http_status(204) }
      it { expect(Attachment.exists? attach).to be_falsey }
    end

    context 'when a resourse is not found' do
      before { delete api_attachment_path(attach.id + 1), {}, {Accept: Mime::JSON} }
 
      it { is_expected.to have_http_status(404).and have_content_type(:json) }
    end

    context 'when a wrong format is requested' do
      before { delete api_attachment_path(attach.id), {}, {Accept: Mime::XML} }
 
      it { is_expected.to have_http_status(406).and have_content_type(:json) }
      it { expect(Attachment.exists? attach).to be_truthy }
    end

    after { delete_dummy_file }
  end
end
