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
    expect(div(class: 'notice').text).to 'Login successful'
  end

  scenario 'Signing in with wrong credentials' do
    text_field( id: 'user_email').set 'test@marketram.com'
    text_field( id: 'user_password').set 'bad password'
    button(text: 'login').click
    wait
    expect(url).to end_with '/login'
    expect(div(class: 'alert').text).to end_with 'Invalid Login or password.'
  end

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