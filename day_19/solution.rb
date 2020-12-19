require 'benchmark'
require '../colors'

def count_matches(input)
  0
end

def answer_icon(result)
  expected = 2
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
count_matches(example).tap { |result| puts "Rule 0 matches: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Rule 0 matches'.light_blue) do
    result = count_matches(input)
    puts " (#{result})".green
  end
end
