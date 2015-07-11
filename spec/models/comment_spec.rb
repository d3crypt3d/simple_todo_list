require 'spec_helper'

describe Comment do
    before do
        @comment = FactoryGirl.create(:comment)
    end

    subject { @comment }

    it { should be_valid }      #valid with valid attributes
    it { should respond_to(:content) }

    describe "when content is not present" do
        before { @comment.content = " " }
        it { should_not be_valid }
    end
end
