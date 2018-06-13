require 'rails-helper'

describe V1::ProductAPI do
  include Rack::Test::Methods

  def app
    V1::ProductAPI
  end

  describe 'GET /api/v1/products' do

  end

  describe 'POST /api/v1/products' do

  end

  describe 'PUT /api/v1/products/:id' do

  end
end