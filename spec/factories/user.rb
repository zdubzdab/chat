FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@gmail.com" }
    password              'password'
    password_confirmation 'password'

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
