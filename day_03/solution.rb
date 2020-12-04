require 'benchmark'
require '../colors'

def count_trees(rows, step)
  rows.each_with_index.count do |row, index|
    if (index % step[1]) == 0
      row.strip!
      y = index / step[1]
      x = y * step[0]
      row[x % row.length] == '#'
    else
      false
    end
  end
end


def answer_icon(result, step)
  answers = {
    [1, 1] => 2,
    [3, 1] => 7,
    [5, 1] => 3,
    [7, 1] => 4,
    [1, 2] => 2,
  }
  expected = answers[step]
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
.#..#...#.#'.split("\n")

steps = [[1, 1],[3, 1],[5, 1],[7, 1],[1, 2]]

puts 'Example:'
count_trees(example, [1, 1]).tap { |result| puts "x+1, y+1: #{result} #{answer_icon(result, [1, 1])}" }
count_trees(example, [3, 1]).tap { |result| puts "x+3, y+1: #{result} #{answer_icon(result, [3, 1])}" }
count_trees(example, [5, 1]).tap { |result| puts "x+5, y+1: #{result} #{answer_icon(result, [5, 1])}" }
count_trees(example, [7, 1]).tap { |result| puts "x+7, y+1: #{result} #{answer_icon(result, [7, 1])}" }
count_trees(example, [1, 2]).tap { |result| puts "x+1, y+2: #{result} #{answer_icon(result, [1, 2])}" }
product = steps.map {|step| count_trees(example, step)}.reduce(:*)
puts "Product: #{product}"
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  steps.each do |step|
    benchmark.report("x+#{step[0]}, y+#{step[1]}:".light_blue) do
      puts " (#{count_trees(input, step)})".green
    end
  end

  benchmark.report('Product'.light_blue) do
    product = steps.map {|step| count_trees(input, step)}.reduce(:*)
    puts " (#{product})".green
  end
end
