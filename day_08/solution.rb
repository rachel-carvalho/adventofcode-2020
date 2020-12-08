require 'benchmark'
require '../colors'

def parse_line(line)
  line.strip.scan(/(\w{3}) ((\+|\-)\d+)/).first.tap { |result| result[1] = result[1].to_i }
end

def find_accumulator(lines)
  executed_lines = {}
  current_line = 0

  loop do
    need_a_break = executed_lines.key?(current_line)
    return [executed_lines.values.sum, need_a_break, executed_lines] if need_a_break || current_line >= lines.count

    operation, value = parse_line(lines[current_line])
    acc = operation == 'acc' ? value : 0
    executed_lines[current_line] = acc
    current_line += operation == 'jmp' ? value : 1
  end
end

def find_accumulator_with_fix(lines)
  parsed_lines = lines.each_with_index.map do |line, index|
    operation, value = parse_line(line)
    [index, operation, value]
  end

  # try to change non zero nops to jmps
  parsed_lines.filter do |line|
    index, operation, value = line
    operation == 'nop' && value != 0
  end.each do |nop|
    nop_to_jmp = parsed_lines.dup
    jmp = nop.dup
    jmp[1] = 'jmp'
    nop_to_jmp[jmp[0]] = jmp
    accumulator, infinite_loop = find_accumulator(nop_to_jmp.map(&method(:from_parsed_to_string)))

    return accumulator unless infinite_loop
  end

  # try to change jmps to nops from last to first
  _, _, executed_lines = find_accumulator(lines)
  executed_lines.keys.reverse.filter { |number| parsed_lines[number][1] == 'jmp' }.each do |number|
    jmp_to_nop = parsed_lines.dup
    before = jmp_to_nop[number].dup
    jmp_to_nop[number][1] = 'nop'
    accumulator, infinite_loop = find_accumulator(jmp_to_nop.map(&method(:from_parsed_to_string)))
    return accumulator unless infinite_loop
  end

  0
end

def from_parsed_to_string(line)
  "#{line[1]} #{'%+d' % line[2]}"
end

def answer_icon(result, jump_fix)
  expected = jump_fix ? 8 : 5
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
find_accumulator(example).first.tap { |result| puts "Accumulator before infinite loop: #{result} #{answer_icon(result, false)}" }
find_accumulator_with_fix(example).tap { |result| puts "Accumulator with jump fix: #{result} #{answer_icon(result, true)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Accumulator before infinite loop'.light_blue) do
    puts " (#{find_accumulator(input).first})".green
  end
  benchmark.report('Accumulator with jump fix'.light_blue) do
    puts " (#{find_accumulator_with_fix(input)})".green
  end
end
