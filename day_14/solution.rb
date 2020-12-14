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

def mask_address_and_sum(program)
  memory = {}
  mask = nil
  program.each do |line|
    if line.include? 'mask'
      mask = line[/(X|1|0){36}/]
    else
      index, value = line.scan(/mem\[(\d+)\] \= (\d+)/).first
      masked_addresses(mask, index.to_i).each do |address|
        memory[address] = value.to_i
      end
    end
  end

  memory.values.sum
end

def masked_addresses(mask, address)
  mask_chars = mask.chars
  binary = address.to_s(2).rjust(mask_chars.count, '0')
  mask_chars.each_with_index do |char, index|
    next if char == 'X'
    binary[index] = (binary[index].to_i | char.to_i).to_s
  end

  items = [binary]

  mask_chars.each_with_index do |char, index|
    next if char != 'X'
    new_items = []
    items.each do |zero_bit|
      one_bit = zero_bit.dup
      zero_bit[index] = '0'
      one_bit[index] = '1'
      new_items << one_bit
    end
    items.concat new_items
  end

  items.map {|address| address.to_i(2) }
end

def answer_icon(result, address_mask = false)
  expected = address_mask ? 208 : 165
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0'.split "\n"

example2 =
'mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1'.split "\n"

puts 'Example:'
mask_and_sum_memory(example).tap { |result| puts "Masked values sum: #{result} #{answer_icon(result)}" }
mask_address_and_sum(example2).tap { |result| puts "Masked addresses sum: #{result} #{answer_icon(result, true)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Masked values sum'.light_blue) do
    result = mask_and_sum_memory(input)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 6386593869035
  end
  benchmark.report('Masked addresses sum'.light_blue) do
    result = mask_address_and_sum(input)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 4288986482164
  end
end
