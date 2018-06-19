require 'rails_helper'

describe V1::LoanFeeAPI do
  include Rack::Test::Methods

  def app
    V1::LoanFeeAPI
  end

  let(:user) { FactoryBot.create(:user) }
  let(:va_headers) { valid_headers user.id }
  let(:ex_headers) { expired_headers user.id }

  describe 'GET /api/v1/loan_fees.json' do
    let(:credit_eval) { FactoryBot.create(:credit_eval, score_gteq: 0, score_lt: 100)}
    let(:credit_eval1) { FactoryBot.create(:credit_eval, score_gteq: 100, score_lt: 200)}
    let!(:loan_fee) { FactoryBot.create(:loan_fee, credit_eval_id: credit_eval.id) }
    let!(:loan_fee1) { FactoryBot.create(:loan_fee, credit_eval_id: credit_eval1.id) }
    let!(:loan_fee2) { FactoryBot.create(:loan_fee, times: 2, credit_eval_id: credit_eval1.id) }

    context 'when request is invalid' do
      it 'return 401 when no token' do
        get '/api/v1/loan_fees.json'
        expect(last_response.status).to eq 401
      end

      it 'return 401 when expired token' do
        get '/api/v1/loan_fees.json', {}, ex_headers
        expect(last_response.status).to eq 401
      end
    end

    describe 'return a list of loan_fees' do
      context 'when request is valid' do
        it 'return all loan_fees' do
          get '/api/v1/loan_fees.json', nil, va_headers
          expect(last_response.status).to eq 200
          json = JSON.parse(last_response.body)
          expect(json['loan_fees'].size).to eq 3
        end
      end

      context 'when filter params' do
        it 'return loan_fees with filter times' do
          get '/api/v1/loan_fees', {times: loan_fee.times}, va_headers
          expect(last_response.status).to eq 200
          expect(json_response[:loan_fees].size).to eq 2
        end

        it 'return loan_fees with filter period' do
          period = [loan_fee.product.period_num, loan_fee.product.period_unit].join
          get '/api/v1/loan_fees', {period: period}, va_headers
          expect(last_response.status).to eq 200
          expect(json_response[:loan_fees].size).to eq 1
        end
      end
    end
  end

  describe 'POST /api/v1/loan_fees' do
    before {
      header 'Authorization', valid_token(user.id)
    }

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

    it 'work' do
      post '/api/v1/loan_fees', body
      expect(last_response.status).to eq 201
      json = JSON.parse(last_response.body)
      expect(json['active']).to eq true
    end

    it 'require product' do
      post '/api/v1/loan_fees', body.except(:product_id)
      expect(last_response.status).to eq 400
      expect(json_response[:error]).to eq 'product_id is missing'
    end

    it 'require credit_eval' do
      post '/api/v1/loan_fees', body.except(:credit_eval_id)
      expect(last_response.status).to eq 400
      expect(json_response[:error]).to eq 'credit_eval_id is missing'
    end

    it 'require times' do
      post '/api/v1/loan_fees', body.except(:times)
      expect(last_response.status).to eq 400
      expect(json_response[:error]).to eq 'times is missing'
    end
  end

  describe 'PUT /api/v1/loan_fees/:id' do
    let(:loan_fee) {FactoryBot.create(:loan_fee)}
    let(:body) do
      {
        times: 2,
        monthly_fee: 1.99,
        active: false
      }
    end

    it 'work' do
      put "/api/v1/loan_fees/#{loan_fee.id}", body, va_headers
      expect(last_response.status).to eq 200
      last_loan_fee = LoanFee.first
      expect(last_loan_fee.times).to eq body[:times]
      expect(last_loan_fee.monthly_fee).to eq body[:monthly_fee]
      expect(last_loan_fee.active).to eq body[:active]
      expect(last_loan_fee.user_id).to eq user.id
    end

    it 'invalid times' do
      put "/api/v1/loan_fees/#{loan_fee.id}", body.merge({times: 3}), va_headers
      expect(last_response.status).to eq 400
      expect(json_response[:error]).to eq 'times does not have a valid value'
    end
  end

end
