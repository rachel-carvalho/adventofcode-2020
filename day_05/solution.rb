require 'benchmark'
require '../colors'

def get_slice(items, lower_half)
  if lower_half
    [items.min, ((items.max - items.min) / 2.0).floor + items.min]
  else
    [((items.max - items.min) / 2.0).ceil + items.min, items.max]
  end
end

def find_max_seat_id(passes)
  passes.map do |pass|
    row = [0, 127]
    column = [0, 7]
    pass.each_char do |char|
      if %w{F B}.include?(char)
        row = get_slice(row, char == 'F')
      elsif %w{L R}.include?(char)
        column = get_slice(column, char == 'L')
      end
    end
    [pass, {row: row.min, column: column.min, id: row.min * 8 + column.min}]
  end.to_h.tap do |result|
    result[:max] = result.values.map {|p| p[:id]}.max
  end
end

def find_missing_seat(passes)
  parsed_passes = find_max_seat_id(passes)
  parsed_passes.delete :max
  ids = parsed_passes.values.map {|p| p[:id]}.sort
  expected = ids.min
  ids.each do |id|
    return expected if expected != id
    expected += 1
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

  benchmark.report('Missing seat'.light_blue) do
    puts " (#{find_missing_seat(input)})".green
  end
end
