require 'rails_helper'

module Nodes
  RSpec.describe Node, type: :model do
    let(:node)  { create :node }

    it 'has a valid factory'  do
      expect(node).to be_valid
    end

    it 'has a valid build factory'  do
      expect(build(:node)).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:node, name: nil)).not_to be_valid
    end

    it 'is invalid without a title' do
      expect(build(:node, title: nil)).not_to be_valid
    end

  end
end
