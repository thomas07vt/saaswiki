# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assigned_wiki do
    user_id 1
    wiki_id 1
    editor true
  end
end
