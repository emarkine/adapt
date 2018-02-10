require 'rails_helper'

module Nodes
  RSpec.describe Node, type: :model do
    fixtures :nodes
    let(:node)  { Node.find_by_name 'test' }

    it 'has a valid test'  do
      expect(node).to be_valid
    end

    # it 'has a valid build factory'  do
    #   expect(build(:node)).to be_valid
    # end
    #
    # it 'is invalid without a name' do
    #   expect(build(:node, name: nil)).not_to be_valid
    # end
    #
    # it 'is invalid without a title' do
    #   expect(build(:node, title: nil)).not_to be_valid
    # end

  end
end
