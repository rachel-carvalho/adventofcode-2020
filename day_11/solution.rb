require 'matrix'
require 'benchmark'
require '../colors'

def count_occupied_seats(rows, line_of_sight = false)
  rows.each(&:strip!)
  previous_config = rows
  iterations = 0
  loop do
    config = change_occupation(previous_config, line_of_sight)
    iterations += 1
    # puts "-#{iterations}-"
    # puts config.join "\n"
    # puts '---'
    return config.join("\n").count('#') if previous_config == config
    previous_config = config
  end
end

def change_occupation(rows, line_of_sight)
  rows.map.with_index do |line, row|
    line.each_char.with_index.map do |spot, column|
      max_occupied = line_of_sight ? 5 : 4
      if spot == 'L' && count_occupied_around(rows, row, column, line_of_sight).zero?
        '#'
      elsif spot == '#' && count_occupied_around(rows, row, column, line_of_sight) >= max_occupied
        'L'
      else
        spot
      end
    end.join('')
  end
end

def count_occupied_around(rows, row, column, line_of_sight)
  line_of_sight ? count_occupied_line_of_sight(rows, row, column) : count_occupied_adjacent(rows, row, column)
end

def count_occupied_adjacent(rows, row, column)
  count = 0
  ((row - 1)..(row + 1)).each do |adjacent_row|
    ((column - 1)..(column + 1)).each do |adjacent_column|
      neighbor = adjacent_row != row || adjacent_column != column
      if neighbor && adjacent_row >= 0 && adjacent_column >= 0 && adjacent_row < rows.count && adjacent_column < rows[0].length
        count += 1 if rows[adjacent_row][adjacent_column] == '#'
      end
    end
  end
  count
end

def count_occupied_line_of_sight(rows, row, column)
  directions = {
    n: Vector[-1, 0],
    ne: Vector[-1, 1],
    e: Vector[0, 1],
    se: Vector[1, 1],
    s: Vector[1, 0],
    sw: Vector[1, -1],
    w: Vector[0, -1],
    nw: Vector[-1, -1]
  }

  position = Vector[row, column]
  row_count = rows.count
  column_count = rows[0].length
  count = 0
  directions.each do |direction, step|
    iterations = 1
    loop do
      neighbor = position + (step * iterations)
      break if neighbor[0] < 0 || neighbor[0] >= row_count || neighbor[1] < 0 || neighbor[1] >= column_count
      neighbor_line = rows[neighbor[0]]
      spot = neighbor_line && neighbor_line[neighbor[1]]
      count += 1 if spot == '#'
      seat = spot == '#' || spot == 'L'
      break if !spot || seat
      iterations += 1
    end
  end
  count
end

def answer_icon(result, line_of_sight = false)
  expected = line_of_sight ? 26 : 37
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
count_occupied_seats(example, true).tap { |result| puts "Occupied seats: #{result} #{answer_icon(result, true)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Occupied seats'.light_blue) do
    count = count_occupied_seats(input)
    puts " (#{count})".green
    puts ' --> ☠️'.red if count != 2283
  end
  benchmark.report('Occupied seats (line of sight)'.light_blue) do
    count = count_occupied_seats(input, true)
    puts " (#{count})".green
    puts ' --> ☠️'.red if count != 2054
  end
end
