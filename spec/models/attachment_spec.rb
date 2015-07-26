require 'rails_helper'

describe Attachment do
    
    before do
        @attachment = FactoryGirl.create(:attachment)
    end

    subject { @attachment }

    it { should be_valid }          # valid with valid attributes
    it { should respond_to(:filename) }
    it { should respond_to(:mime_type) }
    it { should respond_to(:data) }
    it { should respond_to(:file_upload=) }

    context "it should be valid with a valid file size" do
        before do
             @attachment.file_upload= create_dummy_file(5242880)
        end

        it { expect(@attachment.valid?(:file_upload=)).to be true }
        it { expect(@attachment.data).not_to be_nil }

        after { delete_dummy_file }
    end

    context "it should not be valid with invalid file size" do
        before do
            @attachment.file_upload= create_dummy_file(5242881) 
        end

        it { expect(@attachment.valid?(:file_upload=)).to be false }
        it { expect(@attachment.data).to be_nil }
        
        after { delete_dummy_file }
    end

    def create_dummy_file(required_size)
        file_size = 0
        string = "abcdefghijklmnopqrstuvwxyz123456"

        File.open('dummy_file', 'w') do |f|
            while file_size < required_size       # 5*2^20
                f.print string
                file_size += string.size
            end
        end

        return ActionDispatch::Http::UploadedFile.new(
                                             tempfile: File.new("dummy_file"),
                                             filename: "test.png",
                                             type: "image/png")
    end

    def delete_dummy_file
        File.delete('dummy_file')
    end
end
