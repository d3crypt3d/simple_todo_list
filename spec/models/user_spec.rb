require 'rails_helper'

RSpec.describe User do
  let(:valid_user) { create(:user) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:nickname) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:image) }
  it { is_expected.to respond_to(:encrypted_password) }
  it { is_expected.to respond_to(:reset_password_token) }
  it { is_expected.to respond_to(:reset_password_sent_at) }
  it { is_expected.to respond_to(:remember_created_at) }
  it { is_expected.to respond_to(:sign_in_count) }
  it { is_expected.to respond_to(:current_sign_in_at) }
  it { is_expected.to respond_to(:last_sign_in_at) }
  it { is_expected.to respond_to(:current_sign_in_ip) }
  it { is_expected.to respond_to(:last_sign_in_ip) }
  it { is_expected.to respond_to(:created_at) }
  it { is_expected.to respond_to(:updated_at) }
  it { is_expected.to respond_to(:provider) }
  it { is_expected.to respond_to(:uid) }
  it { is_expected.to respond_to(:confirmation_token) }
  it { is_expected.to respond_to(:confirmed_at) }
  it { is_expected.to respond_to(:confirmation_sent_at) }
  it { is_expected.to respond_to(:unconfirmed_email) }
  it { is_expected.to respond_to(:tokens) }
 
  it { is_expected.to validate_uniqueness_of(:email).scoped_to(:id) }
  it { is_expected.to validate_uniqueness_of(:reset_password_token).scoped_to(:id) }
  it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:id) }
end
