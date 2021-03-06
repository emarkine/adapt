require 'rails_helper'

RSpec.feature 'Login management: ', type: :feature do

  before do
    # @user = Fabricate(:user)
    # @user = create(:user)
    # @user = User.find_by_name 'test'
    # login_user_post(@user.email, 'secret')
  end

  scenario 'Signing in with correct credentials' do
    goto "#{TestHelpers::Features::URL}/login"
    text_field( id: 'email').set 'test@marketram.com'
    text_field( id: 'password').set 'password'
    button(text: I18n.t(:login)).click
    wait
    expect(url).to end_with '/profile'
    expect(div(class: 'notice').text).to have_text I18n.t(:login_success)
  end

  scenario 'Signing in with wrong credentials' do
    goto "#{TestHelpers::Features::URL}/login"
    text_field( id: 'email').set 'test@marketram.com'
    text_field( id: 'password').set 'bad password'
    button(text: I18n.t(:login)).click
    wait
    expect(url).to end_with 'user_sessions'
    expect(div(class: 'alert').text).to have_text I18n.t(:login_failed)
  end

  scenario 'User logged out' do
    login_with_browser
    expect(url).to end_with '/profile'
    a( text: I18n.t('menu.logout')).click
    wait
    expect(div(class: 'notice').text).to have_text I18n.t(:logged_out)
  end

  scenario 'Access to secure page' do
    goto "#{TestHelpers::Features::URL}/profile"
    wait
    expect(url).not_to end_with '/profile'
    expect(div(class: 'alert').text).to have_text I18n.t(:not_authenticated)
  end

end