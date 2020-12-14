require 'benchmark'
require '../colors'

def mask_and_sum_memory(program)
  0
end

def answer_icon(result)
  expected = 165
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0'

puts 'Example:'
mask_and_sum_memory(example).tap { |result| puts "Memory sum: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Memory sum'.light_blue) do
    result = mask_and_sum_memory(input)
    puts " (#{result})".green
  end
end
