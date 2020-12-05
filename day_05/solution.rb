require 'benchmark'
require '../colors'

def find_max_seat_id(passes)
  passes.map do |pass|
    row = [0, 127]
    column = [0, 7]
    pass.each_char do |char|
      if char == 'F'
        row = [row.min, ((row.max - row.min) / 2.0).floor + row.min]
      elsif char == 'B'
        row = [((row.max - row.min) / 2.0).ceil + row.min, row.max]
      elsif char == 'L'
        column = [column.min, ((column.max - column.min) / 2.0).floor + column.min]
      elsif char == 'R'
        column = [((column.max - column.min) / 2.0).ceil + column.min, column.max]
      end
    end
    [pass, {row: row.min, column: column.min, id: row.min * 8 + column.min}]
  end.to_h.tap do |result|
    result[:max] = result.values.map {|p| p[:id]}.max
  end
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
BBFFBBFRLL'.split("\n")

puts 'Example:'
find_max_seat_id(example).tap { |result| puts "Max seat id: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Max seat id'.light_blue) do
    puts " (#{find_max_seat_id(input)[:max]})".green
  end
end
