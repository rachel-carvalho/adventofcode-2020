require 'benchmark'
require '../colors'

def sum_weird_arithmetic(expressions)
  expressions.sum do |expression|
    solve_weird_arithmetic(expression.strip)
  end
end

def solve_weird_arithmetic(expression)
  regexp = /(\d+) (\+|\*) (\d+)/
  while part = expression[regexp]
    operand1, operator, operand2 = part.scan(regexp).first
    result = operator == '+' ? (operand1.to_i + operand2.to_i) : (operand1.to_i * operand2.to_i)
    expression[regexp] = result.to_s
  end
  expression.to_i
end

def answer_icon(result, index)
  answers = [71, 51, 26, 437, 12240, 13632]
  expected = answers[index]
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

examples = [
  '1 + 2 * 3 + 4 * 5 + 6',
  '1 + (2 * 3) + (4 * (5 + 6))',
  '2 * 3 + (4 * 5)',
  '5 + (8 * 3 + 9 + 3 * 4 * 3)',
  '5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))',
  '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'
]

puts 'Example:'
examples.each_with_index do |expression, index|
  solve_weird_arithmetic(expression).tap { |result| puts "Result: #{result} #{answer_icon(result, index)}" }
end
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report('Invalid values sum'.light_blue) do
    result = sum_weird_arithmetic(input)
    puts " (#{result})".green
  end
end
