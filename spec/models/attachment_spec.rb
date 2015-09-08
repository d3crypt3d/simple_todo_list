require 'rails_helper'

RSpec.describe Attachment do

    let(:valid_attachment) { build(:attachment_valid_size) }
    let(:invalid_attachment) { build(:attachment_invalid_size) }
    
    it { is_expected.to respond_to(:filename) }
    it { is_expected.to respond_to(:mime_type) }
    it { is_expected.to respond_to(:data) }
    it { is_expected.to respond_to(:file_upload=) }

    context "with a valid file size" do
        it { expect(valid_attachment.valid?(:file_upload=)).to be_truthy }

        after { delete_dummy_file }
    end

    context 'with an invalid file size' do
        it { expect(invalid_attachment.valid?(:file_upload=)).to be_falsey }

        after { delete_dummy_file }
    end
end
