require 'benchmark'
require '../colors'

def calculate_manhattan_position(instructions)
  0
end

def answer_icon(result)
  expected = 25
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'F10
N3
F7
R90
F11'.split("\n")

puts 'Example:'
calculate_manhattan_position(example).tap { |result| puts "Manhattan position: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Manhattan position'.light_blue) do
    puts " (#{calculate_manhattan_position(input)})".green
  end
end
