
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
end
