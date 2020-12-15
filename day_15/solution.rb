require 'benchmark'
require '../colors'
require 'pry'

def find_nth_number(starting, position)
  numbers = starting.split(',').map(&:to_i)

  positions = numbers.map.with_index.to_a.to_h
  current_position = numbers.count
  last = numbers.last
  positions.delete last

  while current_position < position
    index = positions[last]
    positions[last] = current_position - 1
    if index.nil?
      last = 0
    else
      last = current_position - (index + 1)
    end
    current_position += 1
  end

  last
end

def answer_icon(result, position, index)
  answers = { 2020 => [436, 1, 10, 27, 78, 438, 1836], 30_000_000 => [175594, 2578, 3544142, 261214, 6895259, 18, 362] }
  expected = answers[position][index]
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

examples = [
  '0,3,6',
  '1,3,2',
  '2,1,3',
  '1,2,3',
  '2,3,1',
  '3,2,1',
  '3,1,2'
]

puts 'Example:'
[2020, 30_000_000].each do |position|
  examples.each_with_index do |example, index|
    find_nth_number(example, position).tap { |result| puts "#{example} - #{position}th: #{result} #{answer_icon(result, position, index)}" }
  end
end
puts ''

puts 'Input:'
input = '20,0,1,11,6,3'
Benchmark.bm do |benchmark|
  benchmark.report('2020th'.light_blue) do
    result = find_nth_number(input, 2020)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 421
  end
  benchmark.report('30,000,000th'.light_blue) do
    result = find_nth_number(input, 30_000_000)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 436
  end
end
