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
    pair = numbers.find { |other| other != number && (other + number) == 2020 }
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

def recursive(numbers, operand_count = 2, current_operands = [])
  numbers.each do |number|
    next if current_operands.include? number
    new_operands = current_operands + [number]
    if new_operands.count < operand_count
      found = recursive(numbers, operand_count, new_operands)
      return found if found
    else
      return Result.new(*new_operands) if new_operands.reduce(:+) == 2020
    end
  end
  false
end

example = [1721, 979, 366, 299, 675, 1456]

def answer_icon(result, operands = 2)
  answers = {2 => 514579, 3 => 241861950}
  expected = answers[operands]
  result.product == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

puts 'Example:'
puts '2 operands'
brute_force(example).tap { |result| puts "Brute force: #{result} #{answer_icon(result)}" }
remainder(example).tap { |result| puts "Remainder: #{result} #{answer_icon(result)}" }
remainder_with_hash(example).tap { |result| puts "Remainder with hash: #{result} #{answer_icon(result)}" }
recursive(example).tap { |result| puts "Recursive: #{result} #{answer_icon(result)}" }
puts ''
puts '3 operands'
recursive(example, 3).tap { |result| puts "Recursive: #{result} #{answer_icon(result, 3)}" }
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

  benchmark.report('Recursive 2 operands'.light_blue) do
    puts " (#{recursive(numbers)})".green
  end

  benchmark.report('Recursive 3 operands'.light_blue) do
    puts " (#{recursive(numbers, 3)})".green
  end
end
