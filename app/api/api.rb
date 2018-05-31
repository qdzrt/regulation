class API < Grape::API
  include APIExtensions
  format :json
  prefix :api
  version 'v1', using: :header, vendor: 'twitter'
  mount V1::AuthAPI
  mount V1::UserAPI

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