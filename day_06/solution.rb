require 'benchmark'
require '../colors'

def sum_unique_answers(input)
  input.split("\n\n").sum do |group|
    group.split("\n").map(&:chars).flatten.uniq.count
  end
end

def sum_same_answers(input)
  input.split("\n\n").sum do |group|
    people = group.split("\n")
    people.map(&:chars).flatten.tally.values.count { |answer_count| answer_count == people.count }
  end
end

def answer_icon(result, all_same)
  expected = all_same ? 6 : 11
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
sum_unique_answers(example).tap { |result| puts "Unique answers: #{result} #{answer_icon(result, false)}" }
sum_same_answers(example).tap { |result| puts "All same answers: #{result} #{answer_icon(result, true)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Unique answers'.light_blue) do
    puts " (#{sum_unique_answers(input)})".green
  end
  benchmark.report('All same answers'.light_blue) do
    puts " (#{sum_same_answers(input)})".green
  end
end
