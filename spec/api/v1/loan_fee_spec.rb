require 'rails_helper'

describe V1::LoanFeeAPI do
  include Rack::Test::Methods

  def app
    V1::LoanFeeAPI
  end

  describe 'GET /api/v1/loan_fees.json' do
    let(:user) { FactoryBot.create(:user) }
    let(:valid_headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{auth_headers(user.id)}"} }
    let(:expired_headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{expired_auth_headers(user.id)}"} }
    let!(:loan_fee) { FactoryBot.create(:loan_fee) }
    let!(:loan_fee1) { FactoryBot.create(:loan_fee, times: 2, credit_eval_id: 1) }

    context 'when request is invalid' do
      it 'return 401 when no token' do
        get '/api/v1/loan_fees.json'
        expect(last_response.status).to eq 401
      end

      it 'return 401 when expired token' do
        get '/api/v1/loan_fees.json', {}, expired_headers
        expect(last_response.status).to eq 401
      end
    end

    describe 'return a list of loan_fees' do
      context 'when request is valid' do
        it 'return 200' do
          get '/api/v1/loan_fees.json', nil, valid_headers
          expect(last_response.status).to eq 200
          json = JSON.parse(last_response.body)
          expect(json['loan_fees'].size).to eq(2)
        end
      end

      context 'when request is valid and has params' do
        it 'return a list of loan_fees' do
          get '/api/v1/loan_fees', {times: loan_fee.times}, valid_headers
          expect(last_response.status).to eq(200)
        end
      end
    end
  end

  describe 'POST /api/v1/loan_fees' do
    let(:user) { FactoryBot.create(:user) }
    let(:valid_headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{auth_headers(user.id)}"} }
    let(:product) {FactoryBot.create(:product)}
    let(:credit_eval) {FactoryBot.create(:credit_eval)}
    let(:expected_response) {product.to_json}
    let(:body) do
      {
        credit_eval_id: credit_eval.id,
        product_id: product.id,
        times: 1,
        management_fee: 9.99,
        dayly_fee: 9.99,
        weekly_fee: 9.99,
        monthly_fee: 9.99
      }
    end

    it 'return status 200' do
      post '/api/v1/loan_fees', body, valid_headers
      expect(last_response.status).to eq(201)
      json = JSON.parse(last_response.body)
      expect(json['active']).to eq true
    end

    it 'require product' do

    end

    it 'require credit_eval' do

    end
  end

  describe 'PUT /api/v1/loan_fees/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:valid_headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{auth_headers(user.id)}"} }
    let(:loan_fee) {FactoryBot.create(:loan_fee)}
    let(:body) do
      {
        times: 2,
        monthly_fee: 1.99,
        active: false
      }
    end

    it 'work' do
      put "/api/v1/loan_fees/#{loan_fee.id}", body, valid_headers
      expect(last_response.status).to eq 200
      last_loan_fee = LoanFee.first
      expect(last_loan_fee.times).to eq body[:times]
      expect(last_loan_fee.monthly_fee).to eq body[:monthly_fee]
      expect(last_loan_fee.active).to eq body[:active]
    end
  end

end
