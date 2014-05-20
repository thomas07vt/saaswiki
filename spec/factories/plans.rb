# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan, :class => 'Plans' do
    name "MyString"
    price "9.99"
    pid 1
  end
end
