require 'benchmark'
require '../colors'

class DirectedShip
  DIRECTIONS = {
    'N' => [-1, 0],
    'E' => [0, 1],
    'S' => [1, 0],
    'W' => [0, -1]
  }.freeze

  attr_reader :position, :direction

  def initialize
    @position = [0, 0]
    @direction = 'E'
  end

  def parse_movement(instructions)
    instructions.each do |instruction|
      movement, value = instruction.scan(/(\w)(\d+)/).first
      value = value.to_i

      if %w[L R].include? movement
        rotate(movement, value / 90)
      else
        move_direction = movement == 'F' ? @direction : movement
        move(move_direction, value)
      end
    end
    self
  end

  def to_s
    "#{readable_coordinate(position[1], false)} #{readable_coordinate(position[0], true)} - #{manhattan_position}"
  end

  def manhattan_position
    position.map(&:abs).sum
  end

  private

  def readable_coordinate(point, vertical)
    sign_name = point.positive? ? (vertical ? 'S' : 'E') : (vertical ? 'N' : 'W')
    "#{point.abs}#{sign_name}"
  end

  def move(direction_name, value)
    vector = DIRECTIONS[direction_name]
    @position = [position[0] + vector[0] * value, position[1] + vector[1] * value]
  end

  def rotate(side, times)
    sides = { 'R' => 1, 'L' => -1 }
    steps = sides[side] * times
    next_index = (DIRECTIONS.keys.index(direction) + steps) % DIRECTIONS.keys.count
    @direction = DIRECTIONS.keys[next_index]
  end
end

def answer_icon(result, waypoint = false)
  expected = waypoint ? '214E 72S - 286' : '17E 8S - 25'
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'F10
N3
F7
R90
F11'.split("\n")

puts 'Example:'
DirectedShip.new.parse_movement(example).tap { |result| puts "Manhattan position: #{result} #{answer_icon(result.to_s)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Manhattan position'.light_blue) do
    ship = DirectedShip.new.parse_movement(input)
    puts " (#{ship})".green
    puts ' --> ☠️'.red if ship.to_s != '700E 1256S - 1956'
  end
end
