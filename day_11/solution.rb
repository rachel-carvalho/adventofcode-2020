require 'benchmark'
require '../colors'

def count_occupied_seats(map)
  0
end

def answer_icon(result)
  expected = 37
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL'.split("\n")

puts 'Example:'
count_occupied_seats(example).tap { |result| puts "Occupied seats: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Occupied seats'.light_blue) do
    puts " (#{count_occupied_seats(input)})".green
  end
end
