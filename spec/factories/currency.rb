require 'faker'

FactoryBot.define do

  factory :currency do
    sequence(:name) { Faker::Internet.user_name }
    sequence(:code) {Array.new(3){[*'A'..'Z'].sample}.join}
    sequence(:sign) {Array.new(1){[*'#$%^*&^'].sample}.join}
    country
  end


end