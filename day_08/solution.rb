require 'benchmark'
require '../colors'

def find_accumulator_before_loop(lines)
  0
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
