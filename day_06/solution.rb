require 'benchmark'
require '../colors'

def sum_unique_answers(input)
  input.split("\n\n").sum do |group|
    group.split("\n").map(&:chars).flatten.uniq.count
  end
end

def answer_icon(result)
  expected = 11
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example = 'abc

a
b
c

ab
ac

a
a
a
a

b'

puts 'Example:'
sum_unique_answers(example).tap { |result| puts "Unique answers: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Unique answers:'.light_blue) do
    puts " (#{sum_unique_answers(input)})".green
  end
end
