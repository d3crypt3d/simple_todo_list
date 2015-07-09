require 'spec_helper'

describe Project do

  before do
    @project = FactoryGirl.create(:project) 
  end

  subject { @project }

  it { should be_valid }            #valid with valid attributes
  it { should respond_to(:name) }

  describe "when name is not present" do
    before { @project.name = " "}
    it { should_not be_valid }
  end  
  #pending "add some examples to (or delete) #{__FILE__}"
end
