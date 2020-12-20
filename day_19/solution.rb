require 'benchmark'
require '../colors'
require 'pry'

def count_matches(input)
  rule_section, messages = input.split("\n\n")

  rule = parse_rules(rule_section, ['0']).first

  messages.split("\n").count do |message|
    message.strip!
    regexp = Regexp.new("\\A#{rule}\\z")
    message.match? regexp
  end
end

def count_matches_with_changes(input)
  rule_section, messages = input.split("\n\n")

  rule8, rule42, rule31 = parse_rules(rule_section, ['8', '42', '31'])
  stripped_messages = messages.split("\n").map(&:strip)

  repetitions = 2
  last_count = 0

  rule11 = "(#{rule42}#{rule31})"
  loop do
    rule11 += "|((#{rule42}){#{repetitions}}(#{rule31}){#{repetitions}})"
    rule = "(#{rule8})+(#{rule11})"
    regexp = Regexp.new("\\A#{rule}\\z")
    count = stripped_messages.count { |message| message.match? regexp }

    return count if count > 1 && count == last_count
    last_count = count
    repetitions += 1
  end
end

def parse_rules(input, rule_indexes)
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

def answer_icon(result, test_rule = false, changes = false)
  rule = 'a((aa|bb)(ab|ba)|(ab|ba)(aa|bb))b'
  expected = test_rule ? rule : changes ? 12 : 2
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

example2 =
'42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1

abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba'

puts 'Example:'
parse_rules(example.split("\n\n").first, ['0']).first.tap { |result| puts "First rule: #{result} #{answer_icon(result, true)}" }
count_matches(example).tap { |result| puts "Rule 0 matches: #{result} #{answer_icon(result)}" }
count_matches_with_changes(example2).tap { |result| puts "Rule 0 matches with changes: #{result} #{answer_icon(result, false, true)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Rule 0 matches'.light_blue) do
    result = count_matches(input)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 241
  end
  benchmark.report('Rule 0 matches with changes'.light_blue) do
    result = count_matches_with_changes(input)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 424
  end
end
