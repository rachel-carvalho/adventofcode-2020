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
    possibilities = valid_tickets.transpose.map.with_index do |column, index|
      possible_rules = rules.filter do |name, ranges|
        column.all? { |number| ranges.any? { |range| range.include?(number) } }
      end
      [index, possible_rules.map(&:first)]
    end

    while possibilities.any? { |index, rule_names| rule_names.count > 1 }
      possibilities.each do |index, rule_names|
        if rule_names.count == 1
          possibilities.each { |other_index, other_rules| other_index != index && other_rules.delete(rule_names.first) }
        end
      end
    end

    possibilities.map { |index, rule_names| [rule_names.first, own[index]] }.to_h
  end

  def rules
    @rules ||= @sections[:rules].split("\n").map do |line|
      name, range1_min, range1_max, range2_min, range2_max = line.scan(/\A(.+)\: (\d+)\-(\d+) or (\d+)\-(\d+)/).first
      [name, [range1_min.to_i..range1_max.to_i, range2_min.to_i..range2_max.to_i]]
    end.to_h
  end

  private

  def nearby
    @nearby ||= parse_tickets(@sections[:nearby])
  end

  def valid_tickets
    @valid_tickets ||= nearby.filter do |ticket|
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

  benchmark.report('Own ticket'.light_blue) do
    parser = TicketParser.new(input)
    result = parser.identified
    departure_fields = result.filter { |field, value| field.start_with?('departure ') }
    multiplied = departure_fields.values.reduce(:*)

    puts " (#{result} - #{multiplied})".green
    puts " --> ☠️ #{parser.rules.keys - result.keys}".red if result.keys.count != 20
    puts ' --> ☠️'.red if multiplied != 964373157673
  end
end
