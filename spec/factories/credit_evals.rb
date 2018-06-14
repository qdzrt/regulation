FactoryBot.define do
  factory :credit_eval, :class => :CreditEval do
    sequence(:score_gteq) {|n| n }
    score_lt { score_gteq+99 }
    sequence(:grade) {|n| "#{n}" }
    user
  end
end