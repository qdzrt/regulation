FactoryBot.define do
  factory :loan_fee, :class => :LoanFee do
    credit_eval
    product
    user
    times 1
    management_fee 9.99
    dayly_fee 9.99
    weekly_fee 9.99
    monthly_fee 9.99
    active true
  end
end