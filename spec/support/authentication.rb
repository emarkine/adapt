module AuthenticationForFeatureRequest
  def login user=nil
    User.connection
    user = User.find_by_email 'test@marketram.com' unless user
    # user.update_attributes password: password
    page.driver.post sessions_url, {email: user.email, password: user.password}
    visit root_url
  end
end