#around 100-200 lines, rewrite in one week, no mutability, no external dependencies, does not alter state
#if intended to alter state, done outside of this module, just a transformation?


#write in modules?
#singletons
#singleton classes?
#or just classes? <<
#how does threading and singleton state perform? overlap?
#experiment

require "parallel"

#if needs internal state, classes (try to build without internal, pass along, better to unit test)
class Mult
  attr_accessor :return_sum

  def initialize
    @return_sum = 0
  end

  def double(n)
    sum = n*2
    return sum
  end

  def quad(n)
    sum = double(double(n))
    @return_sum += sum
    return sum
  end

  def return_sum
    @return_sum
  end
end

results = Parallel.map((1..30).to_a, in_threads: 30) { |i| mult = Mult.new; puts mult.quad(6); puts mult.return_sum }

#if does not need internal state (and it souldnt for unit testing purposes), just a transform

class Multiply

  def self.do(init)
    result = double(init)
    result2 = quad(init)
    return multiply(result, result2)
  end

  def self.double(n)
    n*2
  end

  def self.quad(n)
    double(double(n))
  end

  def self.multiply(n, m)
    n*m
  end

end

results = Parallel.map((1..30).to_a, in_threads: 30) { |i| puts Multiply.do(6) }
