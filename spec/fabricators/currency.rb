Fabricator(:currency ) do
  name { Faker::Internet.user_name }
  code {Array.new(3){[*'A'..'Z'].sample}.join}
  sign {Array.new(1){[*'#$%^*&^'].sample}.join}
  country
end