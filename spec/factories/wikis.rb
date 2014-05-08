# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wiki do
    title "MyString"
    body "MyText"
    creator_id 1
  end
end
