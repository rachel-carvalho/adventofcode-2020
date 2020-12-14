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

def first_time_for_sequence(input)
  _, schedule = input.split "\n"
  lines = schedule.split(',').map(&:to_i).map.with_index.filter { |line, index| line.positive? }

  lines.sort_by!(&:first)

  max_line, max_line_index = lines.last
  multiplier, _ = lines[lines.count - 2]

  loop do
    timestamp = max_line * multiplier

    all_arrived = lines.all? do |line, index|
      offset = index - max_line_index
      ((timestamp + offset) % line) == 0
    end

    return timestamp - max_line_index if all_arrived

    multiplier += 1
  end
end

def first_time_for_sequence_with_math(input)
  _, schedule = input.split "\n"
  lines = schedule.split(',').map(&:to_i).map.with_index.filter { |line, index| line.positive? }

  lines.sort_by!(&:first)

  possible_solution = 0
  least_common_denominator = 1
  lines.each do |line, minute_offset|
    while (possible_solution + minute_offset) % line != 0
      possible_solution += least_common_denominator
    end
    least_common_denominator *= line
  end

  possible_solution
end

def answer_icon(result, index = nil)
  answers = [1068781, 3417, 754018, 779210, 1261476, 1202161486]
  expected = index ? answers[index] : {line: 59, leaves: 944, multiplied: 295}
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

examples = [
'939
7,13,x,x,59,x,31,19',
'0
17,x,13,19',
'0
67,7,59,61',
'0
67,x,7,59,61',
'0
67,7,x,59,61',
'0
1789,37,47,1889'
]

puts 'Example:'
first_bus_to_arrive(examples[0]).tap { |result| puts "First bus: #{result} #{answer_icon(result)}" }
examples.each_with_index do |example, index|
  first_time_for_sequence(example).tap { |result| puts "Sequence timestamp naive #{index}: #{result} #{answer_icon(result, index)}" }
  first_time_for_sequence_with_math(example).tap { |result| puts "Sequence timestamp with math #{index}: #{result} #{answer_icon(result, index)}" }
end
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('First bus'.light_blue) do
    result = first_bus_to_arrive(input)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != {line: 823, leaves: 1008175, multiplied: 4938}
  end
  benchmark.report('Sequence timestamp naive'.light_blue) do
    result = first_time_for_sequence(input)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 230903629977901
  end
  benchmark.report('Sequence timestamp with math'.light_blue) do
    result = first_time_for_sequence_with_math(input)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 230903629977901
  end
end
