module TestHelpers
  module Features
    URL = 'localhost:3001'
    def login_with_browser
      user = User.find 1
      goto "#{URL}/login"
      text_field( id: 'email').set user.email
      text_field( id: 'password').set 'password'
      button(text: 'login').click
      wait
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::Features, type: :feature
end

