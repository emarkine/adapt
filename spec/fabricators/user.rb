Fabricator(:user, :class_name => "User") do
  id { sequence }
  country
  currency
  first_name {Faker::Name.first_name}
  username {Faker::Name.first_name}
  mobile {Faker::PhoneNumber.cell_phone}
  email { Faker::Internet.email }
  password '12345678'
  # s = Faker::Crypto.sha256
  # salt { s }
  after_build do |user|
    user.password_confirmation = user.password
  end

    # crypted_password  Sorcery::CryptoProviders::BCrypt.encrypt('secret', s )
end