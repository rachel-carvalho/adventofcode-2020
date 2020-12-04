require 'benchmark'
require '../colors'

def count_valid_passports(file)
  0
end

def answer_icon(result)
  expected = 2
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example = 'ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in'

puts 'Example:'
count_valid_passports(example).tap { |result| puts "Valid passports: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Valid passports'.light_blue) do
    puts " (#{count_valid_passports(input)})".green
  end
end
