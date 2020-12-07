require 'benchmark'
require '../colors'

def count_parent_bags_of(hierarchy_rules, contained_bag)
  find_parents(parents_by_color(hierarchy_rules), contained_bag).flatten.uniq.count
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
        [color, quantity]
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
