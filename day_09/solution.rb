require 'benchmark'
require '../colors'

def find_invalid_number(numbers, preamble_size)
  0
end

def answer_icon(result)
  expected = 127
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
find_invalid_number(example, 5).tap { |result| puts "Invalid number: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Invalid number'.light_blue) do
    puts " (#{find_invalid_number(input, 25)})".green
  end
end
