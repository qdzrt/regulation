FactoryBot.define do
  factory :credit_eval, :class => :CreditEval do
    score_gteq 1
    score_lt 10
    grade '2'
    user
  end
end