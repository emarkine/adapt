require 'rails_helper'

module TestHelpers
  include Sorcery::TestHelpers::Rails::Integration

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
      user = User.find_by_name 'test'
      post user_sessions_path, params: {email: user.email, password: 'password'}
      # follow_redirect!
      # assert_equal session[:user_id].to_i, user.id
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