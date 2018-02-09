# require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user)  { create :user }

  it 'has a valid factory'  do
    expect(user).to be_valid
  end

  it 'has a valid build factory'  do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without a first_name' do
    expect(build(:user, first_name: nil)).not_to be_valid
  end

  it 'is invalid without a email' do
    expect(build(:user, email: nil)).not_to be_valid
  end

  it 'is invalid without a valid email' do
    expect(build(:user, email: 'info@blah')).not_to be_valid
  end

  it 'has a valid password' do
    admin = User.find_by_first_name 'Admin'
    expect(admin.valid_password?('123456')).to be true
  end

  it 'is invalid without a currency' do
    expect(build(:user, currency: nil)).not_to be_valid
  end

  it 'has a currency' do
    expect(user.currency).to be_instance_of Currency
  end

  it 'is invalid without a country' do
    expect(build(:user, country: nil)).not_to be_valid
  end

  it 'has a country' do
    expect(user.country).to be_instance_of Country
  end

  it 'has a balance' do
    expect(user.balance).not_to be_nil
  end

end
