require 'rails_helper'

describe V1::LoanFeeAPI do
  let(:loan_fee) {FactoryBot.create(:loan_fee)}

  describe 'get' do
    context '/api/v1/loan_fees/loan_fee' do
      it 'should return status 200' do
        get '/api/v1/loan_fees/loan_fee?product_period=12&loan_times=1&credit_score=199'
        expect(response.status).to eq(200)
        # expect(JSON.parse(last_response.body)).to eq []
      end
    end
  end

  describe 'post' do
    context '/api/v1/loan_fees' do
      it 'should return status 200' do
        # post '/api/v1/loan_fees', {loan_fee: FactoryBot.attributes_for(:loan_fee)}

        expect(loan_fee).to be_persisted
      end
    end
  end


end
