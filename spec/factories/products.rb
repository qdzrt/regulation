FactoryBot.define do
  factory :product, :class => :Product do
    sequence(:period_num) {|n| n }
    period_unit 'M'
    name {"#{period_num}#{period_unit}"}
    association :user
    active true
  end
end