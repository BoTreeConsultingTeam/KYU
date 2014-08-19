# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    user_id 1
    category_id 1
    grade_id 1
    title "MyString"
    status 1
  end
end
