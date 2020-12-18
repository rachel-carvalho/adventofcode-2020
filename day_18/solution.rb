require 'benchmark'
require '../colors'

def sum_weird_arithmetic(expressions)
  expressions.sum do |expression|
    solve_weird_arithmetic(expression.strip)
  end
end

def solve_weird_arithmetic(expression)
  last_level_parenthesis = /\(\d+( (\*|\+) \d+)+\)/
  while parenthesis = expression[last_level_parenthesis]
    parenthesis = parenthesis[1...-1]
    calculate_simple_operations(parenthesis)
    expression[last_level_parenthesis] = parenthesis
  end
  calculate_simple_operations(expression)
  expression.to_i
end

def calculate_simple_operations(expression)
  simple_operation = /(\d+) (\+|\*) (\d+)/
  while part = expression[simple_operation]
    result = calculate_simple_operation(*part.scan(simple_operation).first)
    expression[simple_operation] = result.to_s
  end
end

def calculate_simple_operation(operand1, operator, operand2)
  operator == '+' ? (operand1.to_i + operand2.to_i) : (operand1.to_i * operand2.to_i)
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
  benchmark.report('Result'.light_blue) do
    result = sum_weird_arithmetic(input)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 5019432542701
  end
end
