RSpec.shared_context 'shared_context_for_request', type: :request do
  let(:user) { create(:email_user, :confirmed_email) }
  let(:user_by_id) { User.find(user.id) } # Supplements the previous one
  let(:token_headers) { response.headers.slice('access-token', 'token-type', 'client', 'expiry', 'uid') }

  before do
    xhr :post, '/auth/sign_in', {email: user.email, password: 'secret123'}
  end
end
