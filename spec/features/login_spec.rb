require 'rails_helper'

RSpec.feature 'Login management: ', type: :feature do

  before do
    goto 'localhost:3001/login'
  end

  scenario 'Signing in with correct credentials' do
    text_field( id: 'user_email').set 'test@marketram.com'
    text_field( id: 'user_password').set 'password'
    button(text: 'login').click
    wait
    expect(url).to end_with '/profile'
    # expect(div(class: 'notice').text).to 'Login successful'
  end
  #
  # let(:wrong_user) { build(:user, login: 'user', password: 'wrong') }
  #
  # scenario 'Signing in with wrong credentials' do
  #   @browser.text_field( id: 'user_login').set wrong_user.login
  #   @browser.text_field( id: 'user_password').set wrong_user.password
  #   @browser.button(text: 'Login').click
  #   @browser.wait
  #   expect(@browser.url).not_to end_with '/cassettes/new'
  #   expect(@browser.div(class: 'alert').text).to end_with 'Invalid Login or password.'
  # end
  #
  # scenario 'User logged out' do
  #   till_name = user_first_till(user)
  #   # link = @browser.a('data-sweet-alert-type' => 'info')
  #   link = @browser.a(text: till_name)
  #   link.click
  #   pause
  #   @browser.button(class: 'swal2-confirm styled').click
  #   @browser.wait
  #   expect(@browser.text.include? 'Je dient in te loggen of je in te schrijven.').to be true
  # end

end