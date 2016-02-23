require 'rails_helper'

RSpec.describe User do
  let(:valid_user) { create(:email_user, :confirmed_email) }
  let(:user_email_match) { build(:email_user, :confirmed_email, email: valid_user.email) }
  let(:user_reset_token) { build(:email_user, :confirmed_email, :password_reset_token) }

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

  it { validate_presence_of(:email) } # if(:email_required?)
  it 'validates email format'  # /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/

  it { validate_presence_of(:password) } 
  it { validate_presence_of(:uid) } 
  it { validate_confirmation_of(:password) } 
  it { validate_length_of(:password).is_at_least(8).is_at_most(128) } # allow_blank: true 

  context 'callbacks' do
    it { is_expected.to callback(:send_reconfirmation_instructions).after(:update).if(:reconfirmation_required?) }
    it { is_expected.to callback(:send_password_change_notification).after(:update) }
    it { is_expected.to callback(:postpone_email_change_until_confirmation_and_regenerate_confirmation_token).before(:update).if(:postpone_email_change?) }

    it { is_expected.to callback(:send_on_create_confirmation_instructions).after(:create).if(:send_confirmation_notification?) }
    it { is_expected.to callback(:generate_confirmation_token).before(:create).if(:confirmation_required?) }
    it { is_expected.to callback(:sync_uid).before(:create) }

    it { is_expected.to callback(:set_empty_token_hash).after(:initialize) }

    it { is_expected.to callback(:set_empty_token_hash).after(:save) }
    it { is_expected.to callback(:sync_uid).before(:save) }
    it { is_expected.to callback(:destroy_expired_tokens).before(:save) }
    it { is_expected.to callback(:remove_tokens_after_password_reset).before(:save) }

    it { is_expected.to callback(:downcase_keys).before(:validation) }
    it { is_expected.to callback(:strip_whitespace).before(:validation) }
  end

  # Testing the uniqueness validation of :email, :reset_password_token and :uid
  # properties against Devise's User model is a tricky thing, probably beacause of
  # it's callbacks shoulda-matcher fails. Let's do this manually. 
  context 'uniqueness validation' do
    before { valid_user }

    it 'doesn\'t save a record when a mail is already taken' do
      expect {
       user_email_match.save!
      }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Email already in use')
    end

    it 'doesn\'t save a record when an reset password token is already taken', debug: true do
      expect {
        valid_user.reset_password_token= user_reset_token.reset_password_token
        valid_user.save
        user_reset_token.save!
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    # uid always syncs with email property before save, when we deal with
    # user, registered by email 
  end
end
