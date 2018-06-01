module Entities
  class ProductEntity < Grape::Entity
    expose :id
    expose :name
    expose :period_num
    expose :period_unit
  end
end