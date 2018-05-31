module APIExtensions
  extend ActiveSupport::Concern

  included do
    include APIError
    include Authorizable
  end
end