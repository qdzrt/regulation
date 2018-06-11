FactoryBot.define do
  sequence(:email) { |n| "person#{n}@example.com" }

  factory :user, :class => :User do
    name "nickname"
    sequence(:email, 1000) { |n| "person#{n}@example.com" }
    password "123"
    password_confirmation "123"
  end
  factory :user2, :class => :User do
    name "nickname2"
    sequence(:email, 1000) { |n| "person#{n}@example.com" }
    password "1232"
    password_confirmation "123"
  end
end