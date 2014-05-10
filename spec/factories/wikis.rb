# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wiki do
    title "My Title"
    body "MyText"
    creator
    public true
  end
end
