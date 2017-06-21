module TestHelpers
  module Features
    def login_user(user, password)
      goto 'localhost:3001/login'
      text_field( id: 'user_email').set 'test@marketram.com'
      text_field( id: 'user_password').set 'password'
      button(text: 'login').click
      wait
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::Features, type: :feature
end

