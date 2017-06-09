require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user)  { create :user }

  it 'has a valid factory'  do
    expect(user).to be_valid
  end

  it 'has a valid build factory'  do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without a email' do
    expect(build(:user, email: nil)).not_to be_valid
  end

  it 'is invalid without a valid email' do
    expect(build(:user, email: 'info@blah')).not_to be_valid
  end

  it 'has a valid password' do
    admin = FactoryGirl.create :admin
    expect(admin.valid_password?('123456')).to be true
  end

end
