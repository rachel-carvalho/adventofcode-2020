require 'benchmark'
require '../colors'

def valid_field?(key_value)
  field, value = key_value

  return true if field == 'cid'

  return value.to_i.to_s == value && (1920..2002).include?(value.to_i) if field == 'byr'
  return value.to_i.to_s == value && (2010..2020).include?(value.to_i) if field == 'iyr'
  return value.to_i.to_s == value && (2020..2030).include?(value.to_i) if field == 'eyr'
  if field == 'hgt'
    return false if value != "#{value.to_i}cm" && value != "#{value.to_i}in"
    return (150..193).include?(value.to_i) if value.end_with?('cm')
    return (59..76).include?(value.to_i) if value.end_with?('in')
    false
  end
  return value =~ /\A#(\d|[a-f]){6}\z/ if field == 'hcl'
  return %w{amb blu brn gry grn hzl oth}.include?(value) if field == 'ecl'
  return value =~ /\A\d{9}\z/ if field == 'pid'
end

def count_valid_passports(file, required_only = true)
  required_fields = %w{byr iyr eyr hgt hcl ecl pid}
  passports = file.split("\n\n")
  passports.count do |passport|
    fields = passport.split(Regexp.new('\s')).map { |field| field.split(':') }.to_h
    (required_fields & fields.keys == required_fields) && (required_only || fields.all?(&method(:valid_field?)))
  end
end

def answer_icon(result, required_only = true)
  expected = required_only ? 8 : 4
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end
example = 'eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007

pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719'

puts 'Example:'
count_valid_passports(example).tap { |result| puts "Required fields: #{result} #{answer_icon(result)}" }
count_valid_passports(example, false).tap { |result| puts "Data validation: #{result} #{answer_icon(result, false)}" }
puts ''

puts 'Input:'
input = File.read('input')
Benchmark.bm do |benchmark|
  benchmark.report('Required fields'.light_blue) do
    puts " (#{count_valid_passports(input)})".green
  end

  benchmark.report('Data validation'.light_blue) do
    puts " (#{count_valid_passports(input, false)})".green
  end
end
