require 'benchmark'
require '../colors'

def find_accumulator_before_loop(lines)
  executed_lines = {}
  current_line = 0

  loop do
    return executed_lines.values.sum if executed_lines[current_line]

    operation, value = lines[current_line].strip.scan(/(\w{3}) ((\+|\-)\d+)/).first
    acc = operation == 'acc' ? value.to_i : 0
    executed_lines[current_line] = acc
    current_line += operation == 'jmp' ? value.to_i : 1
  end
end

def answer_icon(result)
  expected = 5
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example = 'nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6'.split("\n")

puts 'Example:'
find_accumulator_before_loop(example).tap { |result| puts "Accumulator before infinite loop: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Accumulator before infinite loop'.light_blue) do
    puts " (#{find_accumulator_before_loop(input)})".green
  end
end
