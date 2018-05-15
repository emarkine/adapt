require 'rails_helper'

RSpec.describe Node, type: :model do
  fixtures :nodes
  fixtures :structures
  fixtures :crystals
  fixtures :edges
  fixtures :neurons
  fixtures :lines

  let(:node) {Node.find_by_name 'test'}

  it 'has a valid test' do
    expect(node).to be_valid
  end

  it 'is invalid without a name' do
    node.name = nil
    expect(node).not_to be_valid
  end

  it 'is invalid without a title' do
    node.title = nil
    expect(node).not_to be_valid
  end

  it 'has not empty list of structures' do
    expect(node.structures.empty?).to be false
    expect(node.structures.first).to be_instance_of Structure
  end

  it 'has not empty list of edges' do
    expect(node.edges.empty?).to be false
    expect(node.edges.first).to be_instance_of Edge
  end

  it 'has not empty list of crystals' do
    expect(node.crystals.empty?).to be false
    expect(node.crystals.first).to be_instance_of Crystal
  end

  it 'has not empty list of neurons' do
    expect(node.neurons.empty?).to be false
    expect(node.neurons.first).to be_instance_of Neuron::Out
  end

  it 'has not empty list of lines' do
    expect(node.lines.empty?).to be false
    expect(node.lines.first).to be_instance_of Line
  end


end
