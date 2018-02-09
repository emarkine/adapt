# require 'rails_helper'

RSpec.describe Currency, type: :model do
  let(:currency)  { create :currency }

  it 'has a valid factory'  do
    expect(currency).to be_valid
  end

  it 'has a valid build factory'  do
    expect(build(:currency)).to be_valid
  end

  it 'is invalid without a name' do
    expect(build(:currency, name: nil)).not_to be_valid
  end

  it 'is invalid without a code' do
    expect(build(:currency, code: nil)).not_to be_valid
  end

  it 'is invalid without a country' do
    expect(build(:currency, country: nil)).not_to be_valid
  end


end
