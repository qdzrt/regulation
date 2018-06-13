require 'rails_helper'

describe V1::UserAPI do
  include Rack::Test::Methods

  def app
    V1::UserAPI
  end

  describe "GET /api/v1/users/:id" do
    let!(:users) { FactoryBot.create_list(:user, 2) }

    it "should return a list of users" do
      get "/api/v1/users"
      expect(json_response[:users].size).to eq(2)
    end
  end

end
