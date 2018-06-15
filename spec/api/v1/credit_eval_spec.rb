require 'rails_helper'

describe V1::CreditEvalAPI do
  include Rack::Test::Methods

  def app
    V1::CreditEvalAPI
  end

  let(:user) { FactoryBot.create(:user) }
  let(:va_headers) { valid_headers user.id }
  let(:ex_headers) { expired_headers user.id }
  let!(:credit_eval1) { FactoryBot.create(:credit_eval, score_gteq: 100, score_lt: 200) }
  let!(:credit_eval2) { FactoryBot.create(:credit_eval, score_gteq: 200, score_lt: 300) }

  describe 'GET /api/v1/credit_evals' do
    context 'when require is invalid' do
      it 'return 401' do
        get '/api/v1/credit_evals', {}, ex_headers
        expect(last_response.status).to eq 401
      end
    end

    context 'when require is valid' do
      before {
        header 'Authorization', valid_token(user.id)
        get '/api/v1/credit_evals'
      }

      it 'return 200' do
        expect(last_response.status).to eq 200
      end

      it 'return all credit_evals' do
        expect(json_response[:credit_evals].size).to eq 2
      end
    end
  end

  describe 'POST /api/v1/credit_evals' do
    before {
      header 'Authorization', valid_token(user.id)
    }

    it 'return 201' do
      post '/api/v1/credit_evals', FactoryBot.attributes_for(:credit_eval)
      expect(last_response.status).to eq 201
      expect(json_response[:user_id]).to eq user.id
    end

    it 'return 406' do
      post '/api/v1/credit_evals', {score_gteq: 200, score_lt: 300, grade: '2'}
      expect(last_response.status).to eq 406
    end
  end

  describe 'PUT /api/v1/credit_evals/:id' do
    before {
      header 'Authorization', valid_token(user.id)
    }

    it 'update score interval success' do
      put "/api/v1/credit_evals/#{credit_eval2.id}", {score_gteq: 250, score_lt: 350}
      expect(last_response.status).to eq 200
      expect(CreditEval.find(credit_eval2.id).user.id).to eq user.id
    end

    it 'update grade success' do
      put "/api/v1/credit_evals/#{credit_eval2.id}", {grade: '10'}
      expect(last_response.status).to eq 200
      expect(CreditEval.find(credit_eval2.id).user.id).to eq user.id
    end
  end
end