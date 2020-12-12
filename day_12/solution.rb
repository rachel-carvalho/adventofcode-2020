require 'benchmark'
require '../colors'

@directions = {
  'N' => [-1, 0],
  'E' => [0, 1],
  'S' => [1, 0],
  'W' => [0, -1]
}

def calculate_manhattan_position(instructions)
  state = {
    position: [0, 0],
    direction: 'E'
  }

  instructions.each do |instruction|
    move, value = instruction.scan(/(\w)(\d+)/).first
    value = value.to_i

    if %w[L R].include? move
      rotate(state, move, value / 90)
    else
      direction = move == 'F' ? state[:direction] : move
      move(state, direction, value)
    end
  end

  position = "#{readable_coordinate(state[:position][1], false)} #{readable_coordinate(state[:position][0], true)}"

  [position, state[:position].map(&:abs).sum]
end

def readable_coordinate(point, vertical)
  direction = point.positive? ? (vertical ? 'S' : 'E') : (vertical ? 'N' : 'W')
  "#{point.abs}#{direction}"
end

def move(state, direction_name, value)
  direction = @directions[direction_name]
  state[:position] = [state[:position][0] + direction[0] * value, state[:position][1] + direction[1] * value]
end

def rotate(state, side, times)
  sides = { 'R' => 1, 'L' => -1 }
  steps = sides[side] * times
  next_index = (@directions.keys.index(state[:direction]) + steps) % @directions.keys.count
  state[:direction] = @directions.keys[next_index]
end

def answer_icon(result)
  expected = ['17E 8S', 25]
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'F10
N3
F7
R90
F11'.split("\n")

puts 'Example:'
calculate_manhattan_position(example).tap { |result| puts "Manhattan position: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Manhattan position'.light_blue) do
    position = calculate_manhattan_position(input)
    puts " (#{position})".green
    puts ' --> ☠️'.red if position != ["700E 1256S", 1956]
  end
end
