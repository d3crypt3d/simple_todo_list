require 'rails_helper'

RSpec.describe "Users", :type => :request do
  let(:user) { create(:email_user, :confirmed_email) }
  let(:user_by_id) { User.find(user.id) } # Supplements the previous one
  let(:user_by_uid) { User.find_by(uid: '12345') } 
  let(:user_attributes) { attributes_for(:email_user, :success_url) }
  let(:pass_valid_confirm) { attributes_for(:passwords_with_current, :valid_confirm) }
  let(:pass_invalid_confirm) { attributes_for(:passwords_with_current, :invalid_confirm) }
  let(:upd_pass_valid_confirm) { attributes_for(:passwords, :valid_confirm) }
  let(:upd_pass_invalid_confirm) { attributes_for(:passwords, :invalid_confirm) }
  let(:body_email) { JSON.parse(response.body)['data']['email'] }
  let(:token_headers) { response.headers.slice('access-token', 'token-type', 'client', 'expiry', 'uid') }
  let(:last_delivery_email) { ActionMailer::Base.deliveries.last.to.first }
  let(:last_delivery_token) { ActionMailer::Base.deliveries.last.body.match(/reset_password_token=(.*)\"/)[1] }
  let(:raw_qs) { response.location.split('?')[1] }
  let(:qs) { Rack::Utils.parse_nested_query(raw_qs) }

  subject { response } 

  # Email registration. Requires email, password,
  # and password_confirmation params
  describe 'POST /auth' do
    context 'with valid credentials' do
      before { post '/auth', user_attributes }

      it { is_expected.to have_http_status(200) }

      it 'returns a User model in JSON' do
        expect(body_email).to eq(user_attributes[:email])
      end
    end

    context 'with invalid credentials' do
      before { post '/auth', attributes_for(:email_user, :invalid_password) }

      it { is_expected.to have_http_status(403) }
    end
  end
  # Account deletion
  describe 'DELETE /auth' do
    before { delete '/auth', {}, user.create_new_auth_token }

    it { is_expected.to have_http_status(200) }

    it 'deletes a user' do
      refute User.find_by(id: user.id)
    end
  end
  # Account updates. Update an existing user's account settings
  describe 'PUT /auth' do
    context 'with valid credentials' do
      before do
        put '/auth', pass_valid_confirm, user.create_new_auth_token
      end

      it { is_expected.to have_http_status(200) }

      it 'updates a user\'s password' do
        expect(
          user_by_id.valid_password? pass_valid_confirm[:password]
        ).to be_truthy
      end
    end

    context 'when the current password mismatched' do
      before do
        put '/auth', attributes_for(:passwords, :current_invalid), user.create_new_auth_token
      end

      it { is_expected.to have_http_status(403) }
      it 'doesn\'t update a user\'s password' do
        expect(
          user_by_id.valid_password? pass_valid_confirm[:password]
        ).to be_falsey
      end
    end

    context 'when the confirmation password mismatched' do
      before do
        put '/auth', pass_invalid_confirm, user.create_new_auth_token
      end
      # TODO - try to implement shared examples
      it { is_expected.to have_http_status(403) }
      it 'doesn\'t update a user\'s password' do
        expect(
          user_by_id.valid_password? pass_valid_confirm[:password]
        ).to be_falsey
      end
    end
  end
  # Email authentication. Requires email and password as params
  describe 'POST /auth/sign_in' do
    context 'with valid credentials' do
      before do
        xhr :post, '/auth/sign_in', {email: user.email, password: 'secret123'}
      end

      it 'returns a User model in JSON' do
        expect(body_email).to eq(user.email)
      end
      
      # TODO write a custom matcher
      it 'returns an access-token in the header' do
        expect(response.headers.has_key?('access-token')).to be_truthy
      end

      it 'returns a client in the header' do
        expect(response.headers.has_key?('client')).to be_truthy
      end

      it 'updates a token after request' do
        expect {
          get '/tweets', {}, token_headers.merge({Accept: Mime::JSON})
        }.to change{User.first.tokens}
      end
    end

    context 'with invaild credentials' do
      before do
        xhr :post, '/auth/sign_in', {email: user.email, password: 'bogus'}
      end

      it { is_expected.to have_http_status(401) }

      it 'doesn\'t create a session' do
        expect(session).not_to be_loaded
      end

      it 'doesn\'t create an access token' do
        expect(user_by_id.tokens).to be_empty
      end
    end

    context 'with invalid token' do
      before do
        xhr :post, '/auth/sign_in', {email: user.email, password: 'secret123'}
        token_headers['access-token']= 'bogus'
        get '/tweets', {}, token_headers
      end

      it { is_expected.to have_http_status(401) }

      it 'destroys a session' do
        expect(session).not_to be_loaded
      end
    end
  end
  # Ends the user's current session
  describe 'DELETE /auth/sign_out' do
    before do
      xhr :post, '/auth/sign_in', {email: user.email, password: 'secret123'}
      xhr :delete, '/auth/sign_out', token_headers
    end

    it { is_expected.to have_http_status(:ok) }

    it 'invalidates the user\'s authentication token' do
      expect(user_by_id.tokens).to be_empty
    end
  end
  # Destination for client authentication (oAuth authentication services)
  describe 'POST /auth/:provider' do
    context 'when a user with a given mail doesn\'t exist' do
      before do
        Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
        get_via_redirect '/auth/github', {auth_origin_url: '/omniauth/github/callback', omniauth_window_type: 'newWindow'} 
      end

      it 'creates a user' do
        expect(user_by_uid).not_to be_falsey
      end

      it 'creates a token' do
        expect(user_by_uid.tokens).not_to be_empty
      end
    end
  end
  # Validates tokens on return visits to the client.
  # Requires uid, client and access-token as params.
  describe 'GET /validate_token' do
    before do
      xhr :post, '/auth/sign_in', {email: user.email, password: 'secret123'}
    end

    it 'validates a user\'s token' do
      expect {
        get '/auth/validate_token', {}, token_headers 
      }.to change{User.first.tokens}
    end
  end
  # Changes users' passwords. Requires password and password_confirmation as params.
  describe 'PUT /auth/password' do
    before do
      put '/auth/password', upd_pass_valid_confirm, user.create_new_auth_token
    end

    it { is_expected.to have_http_status(200) }

    it 'updates a user\'s password' do
      expect(
        user_by_id.valid_password? upd_pass_valid_confirm[:password]
      ).to be_truthy
    end
  end
  # Sends a password reset confirmation email to users that registered by email.
  # Accepts email and redirect_url as params.
  describe 'POST /auth/password' do
    before do
      xhr :post, '/auth/password', { email: user.email, redirect_url: 'http://127.0.0.1' }
    end

    it 'sends a confirmation email' do
      expect(last_delivery_email).to eq(user.email)
    end
  end
  # Verifies user by password reset token. This route is the destination
  # URL for password reset confirmation. This route must contain
  # reset_password_token and redirect_url params.
  describe 'GET /auth/password/edit' do
    before do
      xhr :post, '/auth/password', { email: user.email, redirect_url: 'http://127.0.0.1' }
    end

    context 'with valid reset token' do
      before do
        get '/auth/password/edit', { reset_password_token: last_delivery_token, redirect_url: 'http://127.0.0.1' }
      end

      it { is_expected.to have_http_status(302) }

      it 'has valid auth params' do
        expect(
          user_by_id.valid_token?(qs['token'], qs['client_id'])
        ).to be_truthy  
      end
    end
  end
end
