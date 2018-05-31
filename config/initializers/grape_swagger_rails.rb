if Rails.env.development?
  GrapeSwaggerRails.options.url      = "api/swagger_doc"
  GrapeSwaggerRails.options.app_name  = 'Swagger'
  GrapeSwaggerRails.options.app_url  = '/'

  # GrapeSwaggerRails.options.api_auth     = 'basic' # Or 'bearer' for OAuth
  # GrapeSwaggerRails.options.api_key_name = 'Authorization'
  # GrapeSwaggerRails.options.api_key_type = 'header'

  # GrapeSwaggerRails .options.hide_url_input =  true
  # GrapeSwaggerRails .options.hide_api_key_input =  true
end