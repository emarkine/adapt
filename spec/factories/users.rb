require 'faker'

FactoryGirl.define do

  factory :user do
    sequence(:first_name) {Faker::Name.first_name}
    sequence(:last_name) {Faker::Name.last_name}
    sequence(:email) {Faker::Internet.email}
    sequence(:username) {Faker::Name.first_name}
    sequence(:mobile) {Faker::PhoneNumber.cell_phone}
    sequence(:password) {Faker::Internet.password}
    currency
    country
    after(:build) do |user|
      user.password_confirmation = user.password
    end
  end

  factory :test, class: User do
    name 'Test'
    mobile '0612345678'
    email 'test@marketram.com'
    # currency Currency.EUR
    password 'password'
    password_confirmation 'password'
  end

  factory :admin, class: User do
    name 'Admin'
    mobile '0612345678'
    email 'admin@marketram.com'
    # currency Currency.EUR
    password '123456'
    password_confirmation '123456'
  end

  factory :eugene, class: User do
    name 'Eugene Markine'
    mobile '0628736786'
    email 'eugene@markine.nl'
    # currency Currency.USD
    password 'secret123'
    password_confirmation 'secret123'
  end

end