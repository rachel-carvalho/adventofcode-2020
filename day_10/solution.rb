require 'benchmark'
require '../colors'

def count_jolt_differences(adapters)
  ([0] + adapters.sort + [adapters.max + 3]).each_cons(2).map do |pair|
    pair.last - pair.first
  end.tally
end

def answer_icon(result, example)
  answers = {
    small: { 1 => 7, 3 => 5 },
    large: { 1 => 22, 3 => 10 }
  }
  expected = answers[example]
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example1 = '16
10
15
5
1
11
7
19
6
12
4'.split("\n").map(&:to_i)

example2 = '28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3'.split("\n").map(&:to_i)

puts 'Example:'
count_jolt_differences(example1).tap { |result| puts "Differences (small): #{result} #{answer_icon(result, :small)}" }
count_jolt_differences(example2).tap { |result| puts "Differences (large): #{result} #{answer_icon(result, :large)}" }
puts ''

puts 'Input:'
input = File.readlines('input').map(&:to_i)
Benchmark.bm do |benchmark|
  benchmark.report('Differences'.light_blue) do
    differences = count_jolt_differences(input)
    puts " (#{differences}: #{differences[1] * differences[3]})".green
  end
end
