require 'benchmark'
require '../colors'

def count_cubes_after(initial_state, cycles = 6)
  0
end

def answer_icon(result)
  expected = 112
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'.#.
..#
###'

puts 'Example:'
count_cubes_after(example).tap { |result| puts "Active cubes: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Active cubes'.light_blue) do
    result = count_cubes_after(input)
    puts " (#{result})".green
  end
end
