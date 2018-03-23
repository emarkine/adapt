require 'rails_helper'

RSpec.describe Currency, type: :model do
  let(:currency)  { Currency.USD }

  it 'has a valid factory'  do
    expect(currency).to be_valid
  end

  it 'is invalid without a name' do
    currency.name = nil
    expect(currency).not_to be_valid
  end

  it 'is invalid without a code' do
    currency.code = nil
    expect(currency).not_to be_valid
  end

  it 'is invalid without a country' do
    currency.country = nil
    expect(currency).not_to be_valid
  end


end
