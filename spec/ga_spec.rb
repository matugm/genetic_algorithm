require_relative '../ga'
require_relative '../chromosome'

describe GeneticAlgorithm do
  let(:ga) { GeneticAlgorithm.new }

  # chromosome_class, p_cross, p_mutation, iterations
  it 'has a run method' do
    ga.run(Chromosome, 1, 1)
  end

  it 'produces a chromosome' do
    random_chromo = ga.generate(Chromosome)

    expect(random_chromo).to be_a Chromosome
    expect(random_chromo.value.size).to be Chromosome::SIZE
  end

  it 'selects two random chromosomes using wheel selection' do
    population = [Chromosome.new("01"), Chromosome.new("10")]
    selection  = ga.select(population)

    expect(selection).to be_a Array
    expect(selection).to have_attributes(size: 2)
  end

  it 'calculates the total population fitness' do
    population = [Chromosome.new("01"), Chromosome.new("10")]

    expect(ga.total_fitness(population)).to eq 2
  end

  it 'calculates the percentage of the wheel for every chromosome' do
    population = [Chromosome.new("01"), Chromosome.new("10")]

    expect(ga.calculate_percentages(population, 2)).to eq [500, 500]
  end

  it 'generates the wheel array' do
    population  = [Chromosome.new("01"), Chromosome.new("10")]
    percentages = [500, 500]

    expect(ga.generate_wheel(population, percentages).size).to  eq 1_000
    expect(ga.generate_wheel(population, percentages).first).to eq population.first
    expect(ga.generate_wheel(population, percentages).last).to  eq population.last
  end

  it 'crossovers two chromosomes' do
    selection = [Chromosome.new("01011"), Chromosome.new("10101")]
    expected  = [Chromosome.new("01001"), Chromosome.new("10111")]

    crossover = ga.crossover(selection, 3, Chromosome).map(&:value)

    expect(crossover).to eq expected.map(&:value)
  end
end
