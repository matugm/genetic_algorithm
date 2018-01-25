require_relative '../chromosome'

describe Chromosome do
  it 'has a fitness method' do
    chromo = Chromosome.new("001001")

    expect(chromo.fitness).to eq 1
  end
end
