require 'rails_helper'

describe V1::AuthAPI do
  include Rack::Test::Methods

  def app
    V1::AuthAPI
  end

  shared_examples 'return authorization result' do |des, active|
    let(:user) { FactoryBot.create(:user, active: active) }
    let(:body) do
      {
        email: user.email,
        password: user.password
      }
    end
    it "return #{des}" do
      post '/api/v1/auth/token', body
      expected_status = active ? 201 : 401
      expect(last_response.status).to eq(expected_status)
    end
  end

  describe 'GET /api/v1/auth' do
    context 'should return token' do
      it_should_behave_like 'return authorization result', 'token', true
    end
    context 'should return inactive' do
      it_should_behave_like 'return authorization result', 'inactive', false
    end
  end

end