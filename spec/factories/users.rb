require 'faker'

FactoryGirl.define do

  factory :user do
    sequence(:name) {Faker::Name.first_name}
    sequence(:surname) {Faker::Name.last_name}
    sequence(:mobile) {Faker::PhoneNumber.cell_phone}
    sequence(:email) {Faker::Internet.email}
    sequence(:password) {Faker::Internet.password}
    after(:build) do |user|
      user.password_confirmation = user.password
    end
  end

  factory :admin, class: User do
    name 'Super'
    surname 'Admin'
    mobile '0612345678'
    email 'admin@marketram.com'
    password '123456'
    password_confirmation '123456'
  end

  factory :eugene, class: User do
    name 'Eugene'
    surname 'Markine'
    mobile '0628736786'
    email 'emarkine@gmail.com'
    password 'secret123'
    password_confirmation 'secret123'
  end

end