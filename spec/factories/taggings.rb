# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tagging do
    tag_id 1
    taggable_id 1
    taggable_type "MyString"
  end
end
