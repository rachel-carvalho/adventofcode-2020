require 'benchmark'
require '../colors'

def find_2020th_number(starting)
  position = 2020
  0
end

def answer_icon(result, index)
  answers = [436, 1, 10, 27, 78, 438, 1836]
  expected = answers[index]
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

examples = [
  '0,3,6',
  '1,3,2',
  '2,1,3',
  '1,2,3',
  '2,3,1',
  '3,2,1',
  '3,1,2'
]

puts 'Example:'
examples.each_with_index do |example, index|
  find_2020th_number(example).tap { |result| puts "#{example} - 2020th: #{result} #{answer_icon(result, index)}" }
end
puts ''

puts 'Input:'
input = '20,0,1,11,6,3'
Benchmark.bm do |benchmark|
  benchmark.report('2020th'.light_blue) do
    result = find_2020th_number(input)
    puts " (#{result})".green
  end
end
