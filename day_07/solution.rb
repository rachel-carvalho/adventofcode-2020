require 'benchmark'
require '../colors'

def count_parent_bags_of(hierarchy_rules, contained_bag)
  find_parents(parents_by_color(hierarchy_rules), contained_bag).flatten.uniq.count
end

def total_children_bags(hierarchy_rules, bag)
  count_children(parse_rules(hierarchy_rules), bag)
end

def count_children(rules, bag)
  rules[bag].map do |color, count|
    count + count * count_children(rules, color)
  end.sum
end

def parents_by_color(hierarchy_rules)
  rules = parse_rules(hierarchy_rules)
  rules.map do |parent, children|
    children.keys.map do |child|
      [child, parent]
    end
  end.compact.flatten(1).group_by(&:first).map { |color, pair| [color, pair.map(&:last)] }.to_h
end

def parse_rules(hierarchy_rules)
  hierarchy_rules.map do |rule|
    rule.strip!
    rule.delete_suffix! '.'
    parent, inner = rule.split(' bags contain ')
    contained = {}
    if inner != 'no other bags'
      contained = inner.split(', ').map do |bag|
        quantity, color = bag.scan(/\A(\d+) (.+) bags?\z/).flatten
        [color, quantity.to_i]
      end.to_h
    end
    [parent, contained]
  end.to_h
end

def find_parents(parents_by_color, color, current_parents = [])
  parents = parents_by_color[color]
  return current_parents unless parents
  parents.map do |parent|
    find_parents(parents_by_color, parent, current_parents + parents)
  end
end

def answer_icon(result, example, part)
  answers = {
    first: { part1: 4, part2: 32 },
    second: { part2: 126 }
  }
  expected = answers[example][part]
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

example2 = 'shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.'.split("\n")

puts 'Example:'
my_bag = 'shiny gold'
count_parent_bags_of(example, my_bag).tap { |result| puts "Count parents of #{my_bag}: #{result} #{answer_icon(result, :first, :part1)}" }
total_children_bags(example, my_bag).tap { |result| puts "Total children bags for #{my_bag} (example 1): #{result} #{answer_icon(result, :first, :part2)}" }
total_children_bags(example2, my_bag).tap { |result| puts "Total children bags for #{my_bag} (example 2): #{result} #{answer_icon(result, :second, :part2)}" }
puts ''

puts 'Input:'
input = File.readlines('input')
Benchmark.bm do |benchmark|
  benchmark.report("Count parents of #{my_bag.yellow}".light_blue) do
    puts " (#{count_parent_bags_of(input, my_bag)})".green
  end
  benchmark.report("Total children bags for #{my_bag.yellow}".light_blue) do
    puts " (#{total_children_bags(input, my_bag)})".green
  end
end
