require 'benchmark'
require '../colors'
require 'pry'

def count_parent_bags_of(hierarchy_rules, contained_bag)
  parents_by_color = hierarchy_rules.map do |rule|
    rule.strip!
    rule.delete_suffix! '.'
    parent, inner = rule.split(' bags contain ')
    if inner != 'no other bags'
      inner.split(', ').map do |bag|
        color = bag[/\A\d+ (.+) bags?\z/, 1]
        binding.pry unless color
        [color, parent]
      end
    end
  end.compact.flatten(1).group_by(&:first).map { |color, pair| [color, pair.map(&:last)] }.to_h

  find_parents(parents_by_color, contained_bag).flatten.uniq.count
end

def find_parents(parents_by_color, color, current_parents = [])
  parents = parents_by_color[color]
  return current_parents unless parents
  parents.map do |parent|
    find_parents(parents_by_color, parent, current_parents + parents)
  end
end

def answer_icon(result)
  expected = 4
  result == expected ? '✔'.green : '✗'.red + " expected #{expected}"
end

example = 'light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.'.split("\n")

puts 'Example:'
my_bag = 'shiny gold'
count_parent_bags_of(example, my_bag).tap { |result| puts "Count parents of #{my_bag}: #{result} #{answer_icon(result)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report("Count parents of #{my_bag.yellow}".light_blue) do
    puts " (#{count_parent_bags_of(input, my_bag)})".green
  end
end
