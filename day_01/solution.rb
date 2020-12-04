require 'benchmark'
require '../colors'

class Result
  attr_reader :numbers, :product

  def initialize(*numbers)
    @numbers = numbers
    @product = numbers.reduce(:*)
  end

  def to_s
    "#{numbers.join(', ')}, product: #{product}"
  end
end

def brute_force(numbers)
  numbers.each do |number|
    pair = numbers.find { |other| (other + number) == 2020 }
    return Result.new(number, pair) if pair
  end
end

def remainder(numbers)
  numbers.each do |number|
    rest = 2020 - number
    return Result.new(number, rest) if numbers.any?(rest)
  end
end

def remainder_with_hash(numbers)
  keyed = numbers.map { |n| [n, true] }.to_h
  numbers.each do |number|
    rest = 2020 - number
    return Result.new(number, rest) if keyed[rest]
  end
end

example = [1721, 979, 366, 299, 675, 1456]

def check_answer(result)
  raise 'oops' unless result.product == 514579
end

puts 'Example:'
brute_force(example).tap { |result| puts "Brute force: #{result}"; check_answer(result) }
remainder(example).tap { |result| puts "Remainder: #{result}"; check_answer(result) }
remainder_with_hash(example).tap { |result| puts "Remainder with hash: #{result}"; check_answer(result) }
puts ''

puts 'Input:'
numbers = File.readlines('input').map(&:to_i)
Benchmark.bm do |benchmark|
  benchmark.report('Brute force'.light_blue) do
    puts " (#{brute_force(numbers)})".green
  end

  benchmark.report('Remainder'.light_blue) do
    puts " (#{remainder(numbers)})".green
  end

  benchmark.report('Remainder with hash'.light_blue) do
    puts " (#{remainder_with_hash(numbers)})".green
  end
end
