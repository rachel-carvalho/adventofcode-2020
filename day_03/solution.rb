require 'benchmark'
require '../colors'

def count_trees(rows)
  0
end


def answer_icon(result)
  expected = 7
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example = '..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#'

puts 'Example:'
count_trees(example).tap { |result| puts "Trees: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Trees: #{result}'.light_blue) do
    puts " (#{count_trees(input)})".green
  end
end
