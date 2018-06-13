FactoryBot.define do
  factory :product, :class => :Product do
    period_num 12
    period_unit 'M'
    name {"#{period_num}#{period_unit}"}
    association :user
    active true
  end
end