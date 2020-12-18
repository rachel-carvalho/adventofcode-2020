require 'benchmark'
require '../colors'
require 'pry'

def sum_weird_arithmetic(expressions, addition_precedence = false)
  expressions.sum do |expression|
    solve_weird_arithmetic(expression.strip, addition_precedence)
  end
end

def solve_weird_arithmetic(expression, addition_precedence = false)
  last_level_parenthesis = /\(\d+( (\*|\+) \d+)+\)/
  while parenthesis = expression[last_level_parenthesis]
    parenthesis = parenthesis[1...-1]
    calculate_simple_operations(parenthesis, addition_precedence)
    expression[last_level_parenthesis] = parenthesis
  end
  calculate_simple_operations(expression, addition_precedence)
  expression.to_i
end

def calculate_simple_operations(expression, addition_precedence)
  simple_operation = /(\d+) (\+|\*) (\d+)/
  operations = [simple_operation]
  operations.prepend(/(\d+) (\+) (\d+)/) if addition_precedence
  operations.each do |operation|
    while part = expression[operation]
      result = calculate_simple_operation(*part.scan(operation).first)
      expression[operation] = result.to_s
    end
  end
end

def calculate_simple_operation(operand1, operator, operand2)
  operator == '+' ? (operand1.to_i + operand2.to_i) : (operand1.to_i * operand2.to_i)
end

def answer_icon(result, index, addition_precedence = false)
  answers = addition_precedence ? [231, 51, 46, 1445, 669060, 23340] : [71, 51, 26, 437, 12240, 13632]
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
  solve_weird_arithmetic(expression.dup).tap { |result| puts "Result: #{result} #{answer_icon(result, index)}" }
  solve_weird_arithmetic(expression.dup, true).tap { |result| puts "Addition precedence: #{result} #{answer_icon(result, index, true)}" }
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
  benchmark.report('Addition precedence'.light_blue) do
    result = sum_weird_arithmetic(input, true)
    puts " (#{result})".green
    puts ' --> ☠️'.red if result != 70518821989947
  end
end
