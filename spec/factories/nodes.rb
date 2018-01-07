require 'faker'

FactoryGirl.define do

  factory :node do
    sequence(:name) {Faker::Name.first_name}
    sequence(:title) {Faker::Name.last_name}
    sequence(:file) {"#{Faker::Name.first_name}.txt"}
    sequence(:date) {Faker::Date.between(Time.now - 3.year, Time.now)}
  end

end