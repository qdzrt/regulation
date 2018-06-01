module Entities
  class UserEntity < Grape::Entity
    expose :id
    expose :name
    expose :email
    expose :active
  end
end