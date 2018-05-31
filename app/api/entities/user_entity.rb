module Entities
  class UserEntity < Grape::Entity
    expose :id
    expose :name
    expose :email
  end
end