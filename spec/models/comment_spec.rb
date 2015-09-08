require 'rails_helper'

RSpec.describe Comment do

  it { is_expected.to respond_to(:content) }
  it { is_expected.to validate_presence_of(:content).with_message('can\'t be blank') }
 
  context 'with valid attributes' do
    it { expect(build(:comment)).to be_valid }  
  end
end
