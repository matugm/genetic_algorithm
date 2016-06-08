
class Chromosome
  SIZE = 10

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def fitness
    # Implement in subclass
    1
  end

  def [](index)
    @value[index]
  end

  def mutate(probability_of_mutation)
    @value = value.map { |ch| rand < probability_of_mutation ? invert(ch) : ch }
  end

  def invert(binary)
    binary == "0" ? "1" : "0"
  end
end
