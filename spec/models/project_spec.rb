require 'rails_helper'

RSpec.describe Project do
  # the default subject is already set  
  it { is_expected.to respond_to(:name) }
  it { is_expected.to validate_presence_of(:name).with_message('can\'t be blank') }

  context 'with valid attributes' do
    it { expect(build(:project)).to be_valid }  
  end
end
