# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wiki do
    title "My Title"
    body "MyText"
    creator_id
    public true
  end
end
