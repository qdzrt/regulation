require 'rails_helper'

describe V1::ProductAPI do
  include Rack::Test::Methods

  def app
    V1::ProductAPI
  end

  let(:user) { FactoryBot.create(:user) }
  let(:va_headers) { valid_headers user.id }
  let(:ex_headers) { expired_headers user.id }

  describe 'GET /api/v1/products' do
    context 'when require is invalid' do
      it 'return 401' do
        get '/api/v1/products', {}, ex_headers
        expect(last_response.status).to eq 401
      end
    end

    context 'when require is valid' do
      before {
        FactoryBot.create_list(:product, 5)
        get '/api/v1/products', {}, va_headers
      }

      it 'return 200' do
        expect(last_response.status).to eq 200
      end

      it 'return all products' do
        expect(json_response[:products].size).to eq 5
      end
    end
  end

  describe 'POST /api/v1/products' do
    it 'return 401' do
      post '/api/v1/products', FactoryBot.attributes_for(:product)
      expect(last_response.status).to eq 401
    end

    it 'work' do
      post '/api/v1/products', FactoryBot.attributes_for(:product), va_headers
      expect(last_response.status).to eq 201
    end
  end

  describe 'PUT /api/v1/products/:id' do
    let(:product) { FactoryBot.create(:product) }
    let(:body) do
      {
        name: '12M',
        period_num: 12,
        active: false
      }
    end
    it 'work' do
      put "/api/v1/products/#{product.id}", body, va_headers
      expect(last_response.status).to eq 200
      product = Product.first
      expect(product.name).to eq body[:name]
      expect(product.period_num).to eq body[:period_num]
      expect(product.active).to eq body[:active]
      expect(product.user_id).to eq user.id
    end
  end
end