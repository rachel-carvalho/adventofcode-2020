require 'benchmark'
require '../colors'

def find_invalid_number(items, preamble_size)
  numbers = items.map(&:to_i)

  numbers.each_cons(preamble_size + 1) do |slice|
    *preamble, number = slice
    return number if preamble.none? do |n1|
      (preamble - [n1]).map { |n2| n1 + n2 }.include?(number)
    end
  end
end

def find_invalid_sum_sequence(items, preamble_size)
  numbers = items.map(&:to_i)
  invalid_number = find_invalid_number(items, preamble_size)

  numbers.each_with_index do |number, index|
    sequence_size = 1
    sequence = [number]
    while sequence.count < (numbers.count - index) && sequence.sum < invalid_number do
      sequence << numbers[index + sequence.count]
      return sequence if sequence.sum == invalid_number
    end
  end
end

def answer_icon(result, sequence)
  expected = sequence ? [15, 25, 47, 40] : 127
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example = '35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576'.split("\n")

puts 'Example:'
find_invalid_number(example, 5).tap { |result| puts "Invalid number: #{result} #{answer_icon(result, false)}" }
find_invalid_sum_sequence(example, 5).tap { |result| puts "Sequence which sums to invalid: #{result} #{answer_icon(result, true)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Invalid number'.light_blue) do
    puts " (#{find_invalid_number(input, 25)})".green
  end
  benchmark.report('Sequence which sums to invalid'.light_blue) do
    sequence = find_invalid_sum_sequence(input, 25)
    puts " (#{sequence}: #{sequence.min + sequence.max})".green
  end
end
