FactoryBot.define do
  factory :product, :class => :Product do
    period_num 1
    period_unit 'M'
    name {"#{period_num}#{period_unit}"}
    user
    active false
  end
end