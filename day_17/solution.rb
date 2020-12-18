require 'benchmark'
require '../colors'
require 'pry'

def count_cubes_after(initial_state, fourth_dimention = false)
  universe = {}
  initial_state.split("\n").each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      coordinates = ([0] * (fourth_dimention ? 2 : 1)) + [y, x]
      universe[coordinates] = char
    end
  end

  draw(universe)

  6.times do |n|
    puts "\n"
    puts "cycle #{n + 1}"
    universe = expand(universe)
    draw(universe)
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
  fourth_dimention = []
  offset = universe.keys.map(&:first).min.abs
  four_d = universe.keys.first.count == 4
  universe.each do |coordinates, voxel|
    coords = coordinates.dup
    w = coords.count == 4 ? coords.shift : 0
    z, y, x = coords
    planes = fourth_dimention[w + offset] ||= []
    plane = planes[z + offset] ||= []
    line = plane[y + offset] ||= []
    line[x + offset] ||= voxel
  end
  drawing = fourth_dimention.compact.map.with_index do |planes, windex|
    planes.compact.map.with_index do |plane, zindex|
      bidimentional = plane.compact.map do |line|
        line.join('')
      end
      (["z: #{zindex - offset} w: #{windex - (four_d ? offset : 0)}"] + bidimentional).join("\n")
    end.join("\n\n")
  end.join("\n\n")

  puts drawing
end

def active_neighbors(universe, coordinates)
  coords = coordinates.dup
  fourth_dimention = coords.count == 4
  w = fourth_dimention ? coords.shift : nil
  z, y, x = coords

  new_neighbors = []
  w_range = fourth_dimention ? ((w - 1)..(w + 1)) : [0]
  active = w_range.map do |neighbor_w|
    ((z - 1)..(z + 1)).map do |neighbor_z|
      ((y - 1)..(y + 1)).map do |neighbor_y|
        ((x - 1)..(x + 1)).map do |neighbor_x|
          neighbor = [neighbor_z, neighbor_y, neighbor_x]
          neighbor.prepend(neighbor_w) if fourth_dimention
          new_neighbors << neighbor unless universe[neighbor]
          neighbor == coordinates ? '.' : universe[neighbor] || '.'
        end
      end
    end
  end.flatten.count('#')

  [active, new_neighbors]
end

def answer_icon(result, fourth_dimention = false)
  expected = fourth_dimention ? 848 : 112
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'.#.
..#
###'

puts 'Example:'
count_cubes_after(example).tap { |result| puts "Active cubes: #{result} #{answer_icon(result)}" }
count_cubes_after(example, true).tap { |result| puts "Active hypercubes: #{result} #{answer_icon(result, 4)}" }
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
    puts ' --> ☠️'.red if result != 2236
  end
end
