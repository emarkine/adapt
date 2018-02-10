Fabricator(:person) do
  neighborhood
  houses(count: 2)
  name { Faker::Name.name }
  age 45
  gender { %w(M F).sample }
end