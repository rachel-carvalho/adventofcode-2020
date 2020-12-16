require 'benchmark'
require '../colors'

class TicketParser
  attr_reader :rules, :own, :nearby

  def initialize(input)
    rule_definition, own, nearby = input.split "\n\n"
    @rules = parse_rules(rule_definition)
    @own = parse_tickets(own)
    @nearby = parse_tickets(nearby)
  end

  def invalid_values
    nearby.flatten.filter do |number|
      rules.values.flatten.none? { |range| range.include?(number) }
    end
  end

  private

  def parse_rules(definition)
    definition.split("\n").map do |line|
      name, range1_min, range1_max, range2_min, range2_max = line.scan(/(\w+)\: (\d+)\-(\d+) or (\d+)\-(\d+)/).first
      [name, [range1_min.to_i..range1_max.to_i, range2_min.to_i..range2_max.to_i]]
    end.to_h
  end

  def parse_tickets(input)
    input.split("\n")[1..].map do |line|
      line.split(',').map(&:to_i)
    end
  end
end

def answer_icon(result)
  expected = [4, 55, 12]
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12'

puts 'Example:'
TicketParser.new(example).invalid_values.tap { |result| puts "Invalid values sum: #{result} - #{result.sum} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Invalid values sum'.light_blue) do
    result = TicketParser.new(input).invalid_values
    puts " (#{result.sum})".green
    puts ' --> ☠️'.red if result.sum != 23925
  end
end
