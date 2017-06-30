require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user)  { create :user }

  it 'has a valid factory'  do
    expect(user).to be_valid
  end

  it 'has a valid build factory'  do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without a name' do
    expect(build(:user, name: nil)).not_to be_valid
  end

  it 'is invalid without a email' do
    expect(build(:user, email: nil)).not_to be_valid
  end

  it 'is invalid without a valid email' do
    expect(build(:user, email: 'info@blah')).not_to be_valid
  end

  it 'has a valid password' do
    admin = User.find_by_name 'Admin'
    expect(admin.valid_password?('123456')).to be true
  end

  it 'is invalid without a currency' do
    expect(build(:user, currency: nil)).not_to be_valid
  end

  it 'has a currency' do
    expect(user.currency).to be_instance_of Currency
  end

end
