require 'faker'

FactoryGirl.define do

  factory :user do
    sequence(:first_name) {Faker::Name.first_name}
    sequence(:last_name) {Faker::Name.last_name}
    sequence(:mobile) {Faker::PhoneNumber.cell_phone}
    sequence(:email) {Faker::Internet.email}
    # sequence(:password) {Faker::Internet.password}
  end

  factory :eugene, class: User do
    first_name 'Eugene'
    last_name 'Markine'
    mobile '0628736786'
    email 'emarkine@gmail.com'
    # password 'secret123'
  end

end