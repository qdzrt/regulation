FactoryBot.define do
  factory :user, :class => :User do
    sequence(:name) { |n| "name#{n}" }
    sequence(:email) { |n| "email#{n}@example.com" }
    password "123"
    password_confirmation "123"
    active true
  end
end