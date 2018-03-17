[Article on CodeShip](https://blog.codeship.com/using-genetic-algorithms-in-ruby/?utm_source=CodeshipNewsletter&utm_source=hs_email&utm_campaign=Weekly%20Newsletters&utm_medium=email&utm_content=61364102&_hsenc=p2ANqtz--b0YCcPYozIggC409w7DGk7gc9U7bMYP18oiCoDUh2RIKiWqqiDFJpAchwsylXVsi0RJvqEjKaI9RRS3l7kG4dW3Trtw&_hsmi=61364019
)

# Using Genetic Algorithms in Ruby

Did you know that there’s a way to use the power of natural selection to solve programming challenges? With genetic algorithms (GA), you can solve optimization problems using the same concepts that you find in nature:

* Reproduction
* Survival of the fittest
* Adaptation to the environment

So what’s an optimization problem? It’s when you want to find not just a valid solution but the solution that will give you the best results.

For example, if you have a backpack that only fits a certain amount of stuff and you want to maximize the amount of stuff you can bring, then you could use a genetic algorithm to find the best solution. This is also known as [the knapsack problem](https://en.wikipedia.org/wiki/Knapsack_problem).

The genetic algorithm is not the only way to solve this kind of problem, but it’s an interesting one because it’s modeled after real-world behavior. So let’s learn how they work and how you can implement your own using Ruby.

The genetic algorithm is not the only way to solve this kind of problem, but it’s an interesting one because it’s modeled after real-world behavior. So let’s learn how they work and how you can implement your own using Ruby.

## The Initial Population

The first thing you need in a genetic algorithm is the initial population. This is just a pool of potential solutions that are initially generated at random. A population is made of chromosomes.

> Here’s a key point: Every chromosome represents a potential solution to the problem.

A chromosome can encode a solution in different ways; one is to use a binary string, a string composed of 0s and 1s. Here’s part of the `Chromosome` class:

``` ruby
class Chromosome
  SIZE = 10

  def initialize(value)
    @value = Array.new(SIZE) { ["0", "1"].sample }
  end
end
```

With `Array.new(size)`, you can create a prefilled array with the results from the block, which in this case is a random number between 0 and 1.

This is what a chromosome looks like:

``` ruby
"0010010101"
```

We use a 1 to represent an item inside the backpack and a 0 to represent an item that is not in the backpack.

Now that we have a chromosome, we can generate the initial population:

``` ruby
population = 100.times { Chromosome.new }
```

## Survival of The Fittest

In this step, we want to select the strongest chromosomes (potential solutions) from our population and use them to create the next generation.

There are two components to this:

* The fitness function
* The selection algorithm

The fitness function is used to ‘score’ every chromosome to see how close it is to the optimal solution. This of course depends on the problem we are trying to solve. For the backpack problem, we could use a fitness function that returns a higher score for every item that we are able to fit in.

Here is an example:

``` ruby
CAPACITY = 20

def fitness
  weights = [2, 3, 6, 7, 5, 9, 4]
  values  = [6, 5, 8, 9, 6, 7, 3]

  w = weights
      .map
      .with_index { |w, idx| value[idx].to_i * w }
      .inject(:+)

  v = values
      .map
      .with_index { |v, idx| value[idx].to_i * v }
      .inject(:+)

  w > CAPACITY ? 0 : v
end
```

First, we calculate the total weight of the items to see if we have gone over capacity. Then if we go over capacity, we are going to return a fitness of 0 because this solution is invalid. Otherwise we are going to return the total value of the items that we were able to fit in, because that’s what we are optimizing for.

For example, with the chromosome `"0010011"` and the values and weights given above, we have the items `[6, 9, 4]` inside our backpack, for a total weight of 19. Since that is within capacity, we are going to return the total value for these items, which is `8 + 7 + 3 = 18`.

That becomes the fitness score for this particular chromosome.

## Selection Algorithm

Now let’s go over the selection algorithm. This decides which two chromosomes to evolve at any given time.

There are different ways to implement a selection algorithm, like the [roulette wheel selection algorithm](https://en.wikipedia.org/wiki/Fitness_proportionate_selection) and the _group selection_ algorithm.

Or we can simply pick two random chromosomes. I found this to be good enough as long as you apply _elitism_, which is to keep the best fit chromosomes after every generation.

Here’s the code:

``` ruby
def select(population)
  population.sample(2)
end
```

Next we will learn how we can evolve the selected chromosomes so we can create the next generation and get closer to the optimal solution.

## Genetic Algorithm Evolution

To evolve our selected chromosomes, we can apply two operations: crossover and mutation.

### Crossover

In the crossover operation, you cross two chromosomes at some random point to generate two new chromosomes, which will form part of the next generation.

![Crossover](https://1npo9l3lml0zvr6w62acc3t1-wpengine.netdna-ssl.com/wp-content/uploads/2018/03/OnePointCrossover.svg_.png)

Here’s the crossover method:

```ruby
def crossover(selection, index, chromosome)
  cr1 = selection[0][0...index] + selection[1][index..-1]
  cr2 = selection[1][0...index] + selection[0][index..-1]

  [chromosome.new(cr1), chromosome.new(cr2)]
end
```

We don’t always apply this crossover operation because we want some of the current population to carry over.

### Mutation

The other evolutionary operation we can perform is mutation. Mutation is only applied with a small probability because we don’t want to drift off too much from the current solution.

The purpose of mutation is to avoid getting stuck with a local minima solution.

Implementation:

```ruby
def mutate(probability_of_mutation)
  @value = value.map { |ch| rand < probability_of_mutation ? invert(ch) : ch }
end

def invert(binary)
  binary == "0" ? "1" : "0"
end
```

Now that we have all the components, we can make them work together.

## The Run Method

This method generates the initial population and contains the main loop of the algorithm. It will also find the best-fit solution and return it at the end. It looks something like this:

```Ruby
def run
  # initial population
  population = Array.new(100) { Chromosome.new }

  current_generation = population
  next_generation    = []

  iterations.times {
    (population.size / 2).times {
      # selection
      selection = crossover(select(current_generation), rand(0..Chromosome::SIZE), chromosome)

      # mutation
      selection[0].mutate(p_mutation)
      selection[1].mutate(p_mutation)
    }

    current_generation = next_generation
    next_generation = []
  }

  current_generation.max_by { |ch| ch.fitness }
end
```

This `run` method is defined inside the `GeneticAlgorithm` class, which we can use like this:

```Ruby
ga = GeneticAlgorithm.new
puts ga.run(Chromosome, 0.2, 0.01, 100)
```

The first argument is the chromosome class we are going to use, the second argument is the crossover rate, the third is the argument mutation rate, and the last argument is the number of generations.

## How Do You Know That You Got The Best Solution?

Long story short, you can’t know for sure. What you can do is run a good amount of iterations and trust that the result is either the optimal solution or very close to the optimal solution.

Another option is to keep track of the best-fit chromosome and stop if it doesn’t improve after a certain number of iterations.

## Conclusion

In this article, you learned that genetic algorithms are used to solve optimization problems. You also learned how they work and what components they’re made of (initial population, selection, and evolution).

If you found this article interesting, do us a favor and share this post with as many people as you can so they can enjoy it, too!

[Article on CodeShip](https://blog.codeship.com/using-genetic-algorithms-in-ruby/?utm_source=CodeshipNewsletter&utm_source=hs_email&utm_campaign=Weekly%20Newsletters&utm_medium=email&utm_content=61364102&_hsenc=p2ANqtz--b0YCcPYozIggC409w7DGk7gc9U7bMYP18oiCoDUh2RIKiWqqiDFJpAchwsylXVsi0RJvqEjKaI9RRS3l7kG4dW3Trtw&_hsmi=61364019
)
