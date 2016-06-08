
class GeneticAlgorithm
  def generate(chromosome)
    value = Array.new(chromosome::SIZE) { ["0", "1"].sample }

    chromosome.new(value)
  end

  def reset_wheel
    @total, @percentages, @wheel = nil, nil, nil
  end

  def select(population)
    @total       ||= total_fitness(population)
    @percentages ||= calculate_percentages(population, @total)
    @wheel       ||= generate_wheel(population, @percentages)

    @wheel.sample(2)
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

        selection = select(current_generation)

        if rand < p_cross
          selection = crossover(selection, rand(0..chromosome::SIZE), chromosome)
        end
        # mutation

        next_generation << selection[0] << selection[1]
      }

      current_generation = next_generation
      next_generation    = []

      reset_wheel
    }

    # return best solution
    best_fit = current_generation.max_by { |ch| ch.fitness }

    puts "#{best_fit.value} => #{best_fit.fitness}"
  end
end
