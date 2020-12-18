require 'benchmark'
require '../colors'
require 'pry'

def count_cubes_after(initial_state, dimentions = 3)
  universe = {}
  initial_state.split("\n").each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      universe[[0, y, x]] = char
    end
  end

  # draw(universe)

  6.times do |n|
    # puts "\n"
    # puts "cycle #{n + 1}"
    universe = expand(universe)
    # draw(universe)
  end

  universe.values.count '#'
end

def expand(universe)
  expanded = {}
  to_add = []
  universe.each do |coordinates, voxel|
    active, new_neighbors = active_neighbors(universe, coordinates)
    to_add.concat new_neighbors
    expanded[coordinates] = state(voxel, active)
  end
  to_add.uniq.each do |coordinates|
    active, _ = active_neighbors(universe, coordinates)
    expanded[coordinates] = state('.', active)
  end
  expanded
end

def state(voxel, active)
  return '.' if voxel == '#' && active != 2 && active != 3
  return '#' if voxel == '.' && active == 3
  voxel
end

def draw(universe)
  planes = []
  offset = universe.keys.map(&:first).min.abs
  universe.each do |coordinates, voxel|
    z, y, x = coordinates
    plane = planes[z + offset] ||= []
    line = plane[y + offset] ||= []
    line[x + offset] ||= voxel
  end
  drawing = planes.compact.map.with_index do |plane, zindex|
    bidimentional = plane.compact.map do |line|
      line.join('')
    end
    (["z: #{zindex - offset}"] + bidimentional).join("\n")
  end.join("\n\n")

  puts drawing
end

def active_neighbors(universe, coordinates)
  z, y, x = coordinates
  new_neighbors = []
  active = ((z - 1)..(z + 1)).map do |neighbor_z|
    ((y - 1)..(y + 1)).map do |neighbor_y|
      ((x - 1)..(x + 1)).map do |neighbor_x|
        neighbor = [neighbor_z, neighbor_y, neighbor_x]
        new_neighbors << neighbor unless universe[neighbor]
        neighbor == coordinates ? '.' : universe[neighbor] || '.'
      end
    end
  end.flatten.count('#')

  [active, new_neighbors]
end

def answer_icon(result, dimentions = 3)
  answers = {3 => 112, 4 => 848}
  expected = answers[dimentions]
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'.#.
..#
###'

puts 'Example:'
count_cubes_after(example).tap { |result| puts "Active cubes: #{result} #{answer_icon(result)}" }
count_cubes_after(example, 4).tap { |result| puts "Active hypercubes: #{result} #{answer_icon(result, 4)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Active cubes'.light_blue) do
    result = count_cubes_after(input)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 348
  end
  benchmark.report('Active hypercubes'.light_blue) do
    result = count_cubes_after(input, 4)
    puts " (#{result})".green
  end
end
