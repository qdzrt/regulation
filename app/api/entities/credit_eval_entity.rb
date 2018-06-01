module Entities
  class CreditEvalEntity < Grape::Entity
    expose :id
    expose :score_gteq
    expose :score_lt
    expose :score_interval
    expose :grade
  end
end