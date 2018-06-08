require 'rails_helper'

RSpec.describe "V1::LoanFeeAPI", type: :request do
  describe "GET /api/v1/loan_fees/loan_fee" do
    it "returns an empty array of loan_fees" do
      get '/api/v1/loan_fees/loan_fee'
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq([])
    end
  end
end
