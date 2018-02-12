module TestHelpers
  module Features
    URL = 'localhost:3001'

    def login_with_browser
      user = User.find 1
      goto "#{URL}/login"
      text_field(id: 'email').set user.email
      text_field(id: 'password').set 'password'
      button(text: 'login').click
      wait
    end
  end
  module Requests
    def authenticate
      post sessions_url, params: {session: {email: user.email, password: "123123"}}
      assert_redirected_to workflows_path
      assert_equal session[:user_id].to_i, user.id
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::Features, type: :feature
  config.include TestHelpers::Requests, type: :request
end


#
# module AuthenticationForFeatureRequest
#   def login_user
#     User.connection
#     user = User.find_by_email 'test@marketram.com'
#     page.driver.post sessions_url, {email: user.email, password: user.password}
#   end
# end