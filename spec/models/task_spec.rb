require 'rails_helper'

RSpec.describe Task do

  let(:valid_task) { create(:task) }  

  it { is_expected.to respond_to(:content) }
  it { is_expected.to respond_to(:priority) }
  it { is_expected.to respond_to(:deadline) }
  it { is_expected.to respond_to(:isdone) }
  it { is_expected.to respond_to(:project_id) }
  it { is_expected.to validate_presence_of(:content).with_message('can\'t be blank') }
  it { is_expected.to validate_presence_of(:priority).with_message('can\'t be blank') }
  it { is_expected.to validate_presence_of(:deadline).with_message('can\'t be blank') }
  it { is_expected.to validate_presence_of(:project_id).with_message('can\'t be blank') }
  it { is_expected.to validate_numericality_of(:priority).only_integer }
  it { is_expected.to validate_numericality_of(:priority).is_greater_than(0) }
  it { is_expected.to validate_uniqueness_of(:priority).scoped_to(:project_id) }
    
  context 'with valid attributes' do
    it { expect(build(:task)).to be_valid }  
  end

  context "with the same priority exists inside another project" do
    before { valid_task.project_id += 1 }

    it { expect(valid_task).to be_valid }
  end
end
