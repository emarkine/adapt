# require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country)  { create :country }

  it 'has a valid factory'  do
    expect(country).to be_valid
  end

  it 'has a valid build factory'  do
    expect(build(:country)).to be_valid
  end

  it 'is invalid without a name' do
    expect(build(:country, name: nil)).not_to be_valid
  end

  it 'is invalid without a code' do
    expect(build(:country, code: nil)).not_to be_valid
  end

  it 'has a local' do
    expect(Country.local).to be_an_instance_of Country
  end

end
