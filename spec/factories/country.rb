require 'faker'

FactoryGirl.define do

  factory :country do
    sequence(:name) {Faker::Address.country}
    sequence(:code) {Faker::Address.country_code}
  end

  # factory :US, class: Country do
  #   name 'United States'
  #   code 'US'
  # end
  #
  # factory :NL, class: Country do
  #   name 'Netherlands'
  #   code 'NL'
  # end

end