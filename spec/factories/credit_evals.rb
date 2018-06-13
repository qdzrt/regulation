FactoryBot.define do
  factory :credit_eval, :class => :CreditEval do
    score_gteq 100
    score_lt 200
    grade '2'
    user
  end
end