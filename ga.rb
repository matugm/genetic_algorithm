
class GeneticAlgorithm
  def generate(chromosome)
    value = Array.new(chromosome::SIZE) { ["0", "1"].sample }

    chromosome.new(value)
  end

  def select(population)
    total       = total_fitness(population)
    percentages = calculate_percentages(population, total)
    wheel       = generate_wheel(population, percentages)

    wheel.sample(2)
  end

  def total_fitness(population)
    population.inject(0) { |sum, ch| sum + ch.fitness }
  end

  def calculate_percentages(population, total_fitness)
    population.map { |ch| (ch.fitness / total_fitness.to_f * 1000).to_i }
  end

  def generate_wheel(population, percentages)
    percentages.flat_map.with_index do |percent, idx|
      percent.times.map { population[idx] }
    end
  end

  def crossover(selection, index, chromosome)
    cr1 = selection[0][0...index] + selection[1][index..-1]
    cr2 = selection[1][0...index] + selection[0][index..-1]

    [chromosome.new(cr1), chromosome.new(cr2)]
  end

  def run(chromosome, p_cross, p_mutation, iterations = 100)
    # initial pop
    population = 100.times.map { generate(chromosome) }

    current_generation = population
    next_generation    = []

    iterations.times {
      (population.size / 2).times {
        # selection
        # crossover
        # mutation
      }

      # next generation
    }

    # return best solution
  end
end
