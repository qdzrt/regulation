require 'rails_helper'

describe V1::UserAPI do
  include Rack::Test::Methods

  def app
    V1::UserAPI
  end

  let(:users) { FactoryBot.create_list(:user, 2) }
  let(:valid_headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{auth_headers(users.first.id)}"} }

  describe "GET /api/v1/users/:id" do
    context 'when require is invalid' do
      it 'return 401' do
        get '/api/v1/users'
        expect(last_response.status).to eq 401
      end
    end

    context 'when require is valid' do
      before {
        get '/api/v1/users', {}, valid_headers
      }

      it 'return 200' do
        expect(last_response.status).to eq 200
      end

      it 'return all users' do
        expect(json_response[:users].size).to eq 2
      end
    end
  end

  describe 'POST /api/v1/users' do
    it 'return 401' do
      post '/api/v1/users', FactoryBot.attributes_for(:user)
      expect(last_response.status).to eq 401
    end

    it 'work' do
      post '/api/v1/users', FactoryBot.attributes_for(:user), valid_headers
      expect(last_response.status).to eq 200
    end
  end

  describe 'PUT /api/v1/users/:id' do
    it 'return password not match' do
      put "/api/v1/users/#{users.first.id}", {password: '123456', password_confirmation: '12345678'}, valid_headers
      expect(last_response.status).to eq 406
    end

    it 'return incorrect email format ' do
      put "/api/v1/users/#{users.first.id}", {email: 'qwesdf'}, valid_headers
      expect(json_response[:error]).to eq 'email is invalid'
    end

    it 'work' do
      put "/api/v1/users/#{users.first.id}", {email: 'qwesdf@163.com', active: false}, valid_headers
      expect(last_response.status).to eq 200
      expect(User.first.email).to eq 'qwesdf@163.com'
      expect(User.first.active).to eq false
    end
  end
end
