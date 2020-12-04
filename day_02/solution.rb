require 'benchmark'
require '../colors'

example = '1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc'.split("\n")

class Rule
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

def count_valid_passwords(input)
  input.count do |row|
    rule_string, password = row.split(': ')
    rule = Rule.parse(rule_string)
    rule.valid?(password)
  end
end

def answer_icon(result)
  expected = 2
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

puts 'Example:'
count_valid_passwords(example).tap { |result| puts "#{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('count'.light_blue) do
    puts " (#{count_valid_passwords(input)})".green
  end
end
