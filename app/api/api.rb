# grape doesn't have an autoloading mechanism for custom validators
require_relative 'validators/period'

class API < Grape::API
  mount V1::BaseAPI
end