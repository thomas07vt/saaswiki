# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username, 100) { |n| "dadams{n}" }
    #name "Douglas Adams"
    sequence(:email, 100) { |n| "person#{n}@example.com" }
    password "helloworld"
    password_confirmation "helloworld"
    role "premium"
    plan 1
    confirmed_at Time.now
  end

  factory :basic_user do
    sequence(:username, 100) { |n| "badams{n}" }
    #name "Douglas Adams"
    sequence(:email, 100) { |n| "person#{n}@example.com" }
    password "helloworld"
    password_confirmation "helloworld"
    role "basic"
    plan 0
    confirmed_at Time.now
  end

  factory :enterprise_user do
    sequence(:username, 100) { |n| "eadams{n}" }
    #name "Douglas Adams"
    sequence(:email, 100) { |n| "person#{n}@example.com" }
    password "helloworld"
    password_confirmation "helloworld"
    role "premium"
    plan 2
    confirmed_at Time.now
  end
end
