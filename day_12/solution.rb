require 'benchmark'
require '../colors'

def calculate_manhattan_position(instructions)
  state = {
    position: [0, 0],
    direction: [0, 1]
  }

  instructions.each do |instruction|
    move, value = instruction.scan(/(\w)(\d+)/).first
    value = value.to_i

    case move
    when 'R'
      (value / 90).times { rotate_right(state) }
    when 'L'
      (value / 90).times { rotate_left(state) }
    when 'F'
      state[:position] = [state[:position][0] + state[:direction][0] * value, state[:position][1] + state[:direction][1] * value]
    when 'N'
      state[:position] = [state[:position][0] - value, state[:position][1]]
    when 'S'
      state[:position] = [state[:position][0] + value, state[:position][1]]
    when 'W'
      state[:position] = [state[:position][0], state[:position][1] - value]
    when 'E'
      state[:position] = [state[:position][0], state[:position][1] + value]
    end
  end

  position = "#{readable_coordinate(state[:position][1], false)} #{readable_coordinate(state[:position][0], true)}"

  [position, state[:position].map(&:abs).sum]
end

def readable_coordinate(point, vertical)
  direction = point.positive? ? (vertical ? 'S' : 'E') : (vertical ? 'N' : 'W')
  "#{point.abs}#{direction}"
end

def rotate_right(state)
  if state[:direction] == [0, 1]
    state[:direction] = [1, 0]
  elsif state[:direction] == [1, 0]
    state[:direction] = [0, -1]
  elsif state[:direction] == [0, -1]
    state[:direction] = [-1, 0]
  elsif state[:direction] == [-1, 0]
    state[:direction] = [0, 1]
  end
end

def rotate_left(state)
  if state[:direction] == [0, 1]
    state[:direction] = [-1, 0]
  elsif state[:direction] == [-1, 0]
    state[:direction] = [0, -1]
  elsif state[:direction] == [0, -1]
    state[:direction] = [1, 0]
  elsif state[:direction] == [1, 0]
    state[:direction] = [0, 1]
  end
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
    puts " (#{calculate_manhattan_position(input)})".green
  end
end
