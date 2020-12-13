require 'benchmark'
require '../colors'

def first_bus_to_arrive(schedule)
  0
end

def answer_icon(result)
  expected = 295
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'939
7,13,x,x,59,x,31,19'

puts 'Example:'
first_bus_to_arrive(example).tap { |result| puts "First bus: #{result} #{answer_icon(result.to_s)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('First bus'.light_blue) do
    result = first_bus_to_arrive(input)
    puts " (#{result})".green
  end
end
