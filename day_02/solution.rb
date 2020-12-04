require 'benchmark'
require '../colors'

example = '1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc'.split("\n")

class CharCountRule
  attr_reader :range, :character

  def self.parse(rule_string)
    min_max, character = rule_string.split ' '
    min, max = min_max.split('-')
    range = min.to_i..max.to_i
    new(range, character)
  end

  def initialize(range, character)
    @range = range
    @character = character
  end

  def valid?(password)
    range.include? password.count(character)
  end
end

class CharPositionRule
  attr_reader :index1, :index2, :character

  def self.parse(rule_string)
    positions, character = rule_string.split ' '
    position1, position2 = positions.split('-')
    new(position1.to_i - 1, position2.to_i - 1, character)
  end

  def initialize(index1, index2, character)
    @index1 = index1
    @index2 = index2
    @character = character
  end

  def valid?(password)
    (password[index1] == character) ^ (password[index2] == character)
  end
end

def count_valid_passwords(input, rule_class)
  input.count do |row|
    rule_string, password = row.split(': ')
    rule = rule_class.parse(rule_string)
    rule.valid?(password)
  end
end

def answer_icon(result, rule)
  answers = { CharCountRule => 2, CharPositionRule => 1 }
  expected = answers[rule]
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

puts 'Example:'
count_valid_passwords(example, CharCountRule).tap { |result| puts "Char count rule: #{result} #{answer_icon(result, CharCountRule)}" }
count_valid_passwords(example, CharPositionRule).tap { |result| puts "Char position rule: #{result} #{answer_icon(result, CharPositionRule)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Char count rule: #{result}'.light_blue) do
    puts " (#{count_valid_passwords(input, CharCountRule)})".green
  end

  benchmark.report('Char position rule: #{result}'.light_blue) do
    puts " (#{count_valid_passwords(input, CharPositionRule)})".green
  end
end
