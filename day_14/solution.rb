require 'benchmark'
require '../colors'

def mask_and_sum_memory(program)
  memory = {}
  mask = nil
  program.each do |line|
    if line.include? 'mask'
      mask = line[/(X|1|0){36}/]
    else
      index, value = line.scan(/mem\[(\d+)\] \= (\d+)/).first
      memory[index.to_i] = apply_mask(mask, value.to_i)
    end
  end

  memory.values.sum
end

def apply_mask(mask, value)
  mask_chars = mask.chars
  binary = value.to_s(2).rjust(mask_chars.count, '0')
  mask_chars.each_with_index do |char, index|
    next if char == 'X'
    binary[index] = char
  end
  binary.to_i(2)
end

def answer_icon(result)
  expected = 165
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0'.split "\n"

puts 'Example:'
mask_and_sum_memory(example).tap { |result| puts "Memory sum: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Memory sum'.light_blue) do
    result = mask_and_sum_memory(input)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 6386593869035
  end
end
