require 'benchmark'
require '../colors'

def find_max_seat_id(passes)
  0
end

def answer_icon(result)
  expected = {
    'BFFFBBFRRR' => {row: 70, column: 7, id: 567},
    'FFFBBBFRRR' => {row: 14, column: 7, id: 119},
    'BBFFBBFRLL' => {row: 102, column: 4, id: 820},
    max: 820
  }
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example = 'BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL'

puts 'Example:'
find_max_seat_id(example).tap { |result| puts "Max seat id: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Max seat id'.light_blue) do
    puts " (#{find_max_seat_id(input)})".green
  end
end
