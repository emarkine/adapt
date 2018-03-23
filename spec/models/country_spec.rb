require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country)  { Country.local }

  it 'has a valid factory'  do
    expect(country).to be_valid
  end

  it 'has a valid build factory'  do
    expect(country).to be_valid
  end

  it 'is invalid without a name' do
    country.name = nil
    expect(country).not_to be_valid
  end

  it 'is invalid without a code' do
    country.code = nil
    expect(country).not_to be_valid
  end

  it 'has a local' do
    expect(Country.local).to be_an_instance_of Country
  end

end
