require 'benchmark'
require '../colors'
require 'pry'

def find_corners(input)
  tiles = input.split("\n\n").map do |tile_section|
    title, *lines = tile_section.strip.split("\n")
    number = title[/\d+/].to_i

    lines = lines.map(&:chars)

    top, *middle, bottom = lines
    left = lines.map(&:first)
    right = lines.map(&:last)

    [number, [top, right, bottom, left]]
  end.to_h

  tiles.filter do |number, tile|
    sides_without_match = tile.count do |side|
      side_reversed = side.reverse
      tiles.none? do |other_number, other|
        number != other_number && other.any? { |other_side| side == other_side || side_reversed == other_side }
      end
    end

    sides_without_match == 2
  end.keys
end

def answer_icon(result)
  expected = [1951, 3079, 2971, 1171].sort
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...'

puts 'Example:'
find_corners(example).tap { |result| puts "Corners: #{result.sort} #{answer_icon(result.sort)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Corners'.light_blue) do
    result = find_corners(input)
    puts " (#{result} - #{result.reduce(:*)})".green
    puts ' --> ☠️'.red if result != [1499, 1709, 3083, 1789]
  end
end
