# grape doesn't have an autoloading mechanism for custom validators
require_relative 'validators/period'

class API < Grape::API
  include APIExtensions
  include SharedParams

  format :json
  prefix :api
  version 'v1', using: :header, vendor: 'twitter'
  mount V1::AuthAPI
  mount V1::UserAPI
  mount V1::ProductAPI
  mount V1::CreditEvalAPI
  mount V1::LoanFeeAPI

  helpers do
    def pagination(collection)
      {
        total_count: collection.total_count,
        total_pages: collection.total_pages,
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page
      }
    end
  end

  if Rails.env.development?
    before do
      header['Access-Control-Allow-Origin'] = '*'
      header['Access-Control-Request-Method'] = '*'
    end

    add_swagger_documentation(
      api_version: 'v1',
      base_path: '/',
      hide_documentation_path: true,
      hide_format: true
    )
  end

end