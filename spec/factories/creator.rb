FactoryGirl.define do
  factory :creator, class: User do
    sequence(:username, 100) { |n| "creator{n}" }
    sequence(:email, 100) { |n| "creator#{n}@example.com" }
    password "helloworld"
    password_confirmation "helloworld"
    confirmed_at Time.now
  end
end