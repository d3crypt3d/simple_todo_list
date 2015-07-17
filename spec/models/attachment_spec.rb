require 'rails_helper'

describe Attachment do
    
    before do
        @attachment = FactoryGirl.create(:attachment)
        @file_size = 0
        @string = "abcdefghijklmnopqrstuvwxyz123456"
    end

    subject { @attachment }

    it { should be_valid }          # valid with valid attributes
    it { should respond_to(:filename) }
    it { should respond_to(:mime_type) }
    it { should respond_to(:data) }
    it { should respond_to(:file_upload=) }

    describe "it should be valid with a valid file size" do
        before do
            File.open('dummy_file', 'w') do |f|
                while @file_size < 5242880       # 5*2^20
                    f.print @string
                    @file_size += @string.size
                end
            end
            upload_object = ActionDispatch::Http::UploadedFile.new(
                                             tempfile: File.new("dummy_file"),
                                             filename: "test.png",
                                             type: "image/png")
            @attachment.file_upload= upload_object
        end

        it { expect(@attachment.valid?(:file_upload=)).to be true }

        after do
            File.delete('dummy_file')
        end
    end

    describe "it should not be valid with invalid file size" do
        before do
            File.open('dummy_file', 'w') do |f|
                while @file_size < 5242881       # 5*2^20
                    f.print @string
                    @file_size += @string.size
                end
            end
            upload_object = ActionDispatch::Http::UploadedFile.new(
                                             tempfile: File.new("dummy_file"),
                                             filename: "test.png",
                                             type: "image/png")
            @attachment.file_upload= upload_object
        end

        it { expect(@attachment.valid?(:file_upload=)).to be false }
        
        after do
            File.delete('dummy_file')
        end
    end
end
