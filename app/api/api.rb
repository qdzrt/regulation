# grape doesn't have an autoloading mechanism for custom validators
require_relative 'validators/period'

class API < Grape::API
  format :json
  prefix :api
  version 'v1', using: :path
  mount V1::BaseAPI
end