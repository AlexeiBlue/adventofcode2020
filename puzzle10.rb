adapters = IO.readlines("puzzle10[input]").map(&:chomp).map(&:to_i).sort

one_jolt_diffs = 0
three_jolt_diffs = 1

previous = 0

for j in adapters do
  case j - previous
  when 1
    one_jolt_diffs += 1
  when 3
    three_jolt_diffs += 1
  end
  previous = j
end

print "Part 1: #{one_jolt_diffs * three_jolt_diffs}\n"

# Stolen from https://www.reddit.com/r/adventofcode/comments/ka8z8x/2020_day_10_solutions/gfcaf2q/?utm_source=reddit&utm_medium=web2x&context=3
# Essentially tribonacci, which is like fibonacci but starting with three numbers, maybe?
c = [nil,nil,nil,1]
adapters.each { |i| c[i+3] = c[i..i+2].compact.inject(0){|sum,x| sum + x } }

print "Part 2: #{c.last}\n"