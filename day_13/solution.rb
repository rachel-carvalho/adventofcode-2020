require 'benchmark'
require '../colors'

def first_bus_to_arrive(input)
  availability, schedule = input.split "\n"
  availability = availability.to_i
  lines = schedule.split(',').map(&:to_i).filter(&:positive?).map do |line|
    { line: line, leaves: (availability.to_f / line).ceil * line }
  end.sort_by { |line| line[:leaves] }
  lines.first.merge(multiplied: (lines.first[:leaves] - availability) * lines.first[:line])
end

def answer_icon(result)
  expected = {line: 59, leaves: 944, multiplied: 295}
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'939
7,13,x,x,59,x,31,19'

puts 'Example:'
first_bus_to_arrive(example).tap { |result| puts "First bus: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('First bus'.light_blue) do
    result = first_bus_to_arrive(input)
    puts " (#{result})".green
  end
end
