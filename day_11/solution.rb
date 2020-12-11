require 'benchmark'
require '../colors'

def count_occupied_seats(rows)
  rows.each(&:strip!)
  previous_config = rows
  iterations = 0
  loop do
    config = change_occupation(previous_config)
    iterations += 1
    # puts "-#{iterations}-"
    # puts config.join "\n"
    # puts '---'
    return config.join("\n").count('#') if previous_config == config
    previous_config = config
  end
end

def change_occupation(rows)
  rows.map.with_index do |line, row|
    line.each_char.with_index.map do |spot, column|
      if spot == 'L' && count_occupied_adjacent(rows, row, column).zero?
        '#'
      elsif spot == '#' && count_occupied_adjacent(rows, row, column) >= 4
        'L'
      else
        spot
      end
    end.join('')
  end
end

def count_occupied_adjacent(rows, row, column)
  surrounding_items(rows, row).each_with_index.sum do |adjacent_line, index|
    surrounding_items(adjacent_line.chars, column, index == 1).count do |adjacent_spot|
      adjacent_spot == '#'
    end
  end
end

def surrounding_items(collection, position, remove_self = false)
  empty = collection[position].is_a?(String) ? '' : []
  previous = position == 0 ? empty : collection[position - 1]
  following = position == (collection.count - 1) ? empty : collection[position + 1]
  [previous, remove_self ? nil : collection[position], following].compact
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
