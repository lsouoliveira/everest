FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User#{n}" }
    sequence(:email) { |n| "local-part#{n}domain" }
    password { "password12%%AAzz" }
  end
end
