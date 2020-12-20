require 'benchmark'
require '../colors'
require 'pry'

def count_matches(input)
  rule_section, messages = input.split("\n\n")

  rule = parse_rule(rule_section, ['0']).first

  messages.split("\n").count do |message|
    message.strip!
    regexp = Regexp.new("\\A#{rule}\\z")
    message.match? regexp
  end
end

def parse_rule(input, rule_indexes)
  rules = input.strip.split("\n").map do |line|
    index, rule = line.scan(/(\d+)\: (.*)/).first

    rule.gsub!('"', '') if rule.include?('"')
    rule = "(#{rule})" if rule.include?('|')

    [index, rule]
  end.to_h

  rule_indexes.map do |rule_index|
    rule = rules[rule_index]
    while reference_index = rule[/\d+/]
      rule[/\d+/] = rules[reference_index]
    end

    rule.gsub(' ', '')
  end
end

def answer_icon(result, test_rule = false)
  rule = 'a((aa|bb)(ab|ba)|(ab|ba)(aa|bb))b'
  expected = test_rule ? rule : 2
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example =
'0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb'

puts 'Example:'
parse_rule(example.split("\n\n").first, ['0']).first.tap { |result| puts "First rule: #{result} #{answer_icon(result, true)}" }
count_matches(example).tap { |result| puts "Rule 0 matches: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Rule 0 matches'.light_blue) do
    result = count_matches(input)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 241
  end
end
