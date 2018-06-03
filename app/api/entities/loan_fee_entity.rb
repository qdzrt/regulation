module Entities
  class LoanFeeEntity < Grape::Entity
    expose :id
    expose :product_id
    expose :credit_eval_id
    expose :user_id
    expose :user_name
    expose :credit_eval_id
    expose :management_fee
    expose :dayly_fee
    expose :weekly_fee
    expose :monthly_fee
    expose :times
    expose :active
  end
end