require 'benchmark'
require '../colors'

class TicketParser
  def initialize(input)
    rules, own, nearby = input.split "\n\n"
    @sections = { rules: rules, own: own, nearby: nearby }
  end

  def invalid_values
    nearby.flatten.filter do |number|
      rules.values.flatten.none? { |range| range.include?(number) }
    end
  end

  def identified
    {}
  end

  private

  def nearby
    @nearby ||= parse_tickets(@sections[:nearby])
  end

  def rules
    @rules ||= @sections[:rules].split("\n").map do |line|
      name, range1_min, range1_max, range2_min, range2_max = line.scan(/(\w+)\: (\d+)\-(\d+) or (\d+)\-(\d+)/).first
      [name, [range1_min.to_i..range1_max.to_i, range2_min.to_i..range2_max.to_i]]
    end.to_h
  end

  def valid_nearby
    @valid_nearby ||= nearby.filter do |ticket|
      ticket.all? do |number|
        rules.values.flatten.any? { |range| range.include?(number) }
      end
    end
  end

  def own
    @own ||= parse_tickets(@sections[:own]).first
  end

  def parse_tickets(input)
    input.split("\n")[1..].map do |line|
      line.split(',').map(&:to_i)
    end
  end
end

def answer_icon(result, parsed = false)
  expected = parsed ? { 'class' => 12, 'row' => 11, 'seat' => 13 } : [4, 55, 12]
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

example2 =
'class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
55,2,20'

puts 'Example:'
TicketParser.new(example).invalid_values.tap { |result| puts "Invalid values sum: #{result} - #{result.sum} #{answer_icon(result)}" }
TicketParser.new(example2).identified.tap { |result| puts "Own ticket: #{result} #{answer_icon(result, true)}" }
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
