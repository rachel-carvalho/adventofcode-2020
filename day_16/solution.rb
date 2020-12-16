require 'benchmark'
require '../colors'

def find_invalid_values(input)
  []
end

def answer_icon(result)
  expected = [4, 55, 12]
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12'

puts 'Example:'
find_invalid_values(example).tap { |result| puts "Invalid values sum: #{result} - #{result.sum} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Invalid values sum'.light_blue) do
    result = find_invalid_values(input)
    puts " (#{result.sum})".green
  end
end
