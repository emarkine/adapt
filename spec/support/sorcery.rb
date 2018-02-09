# sorcery

RSpec.configure do |config|
  config.include Sorcery::TestHelpers::Rails::Controller, type: :controller
  config.include Sorcery::TestHelpers::Rails::Integration, type: :feature
  config.include AuthenticationForFeatureRequest, type: :feature
end

  module Sorcery
  module TestHelpers
    module Rails
      def login_user_post(user, password)
        page.driver.post(sessions_url, { username: user, password: password})
      end

      def logout_user_get
        page.driver.get(logout_url)
      end
    end
  end
end
