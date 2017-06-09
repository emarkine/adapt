module TestHelpers
  module Features
    def login_user(user, password)
      visit user_sessions_url
      fill_in 'email',    with: user.email
      fill_in 'password', with: password
      click_button 'Login'
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::Features, type: :feature
end

