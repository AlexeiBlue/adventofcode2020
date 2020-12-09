import org.testng.collections.Sets
import java.util.AbstractMap.SimpleEntry

class Puzzle7 {
    final NO_BAGS = "no other bags"

    private static <T> void mergeTo(final Map<String, Set<T>> bagMap, final String key, final T value) {
        bagMap.merge(key, Sets.newHashSet(value), (existing, current) -> existing + current)
    }

    static SimpleEntry<String, Integer> bagCount(final String bag, final Integer count) {
        return new SimpleEntry(bag, count)
    }

    def part1(final String input) {
        def bagMap = new HashMap<String, Set<String>>()

        Puzzle7.class.getResourceAsStream(input).eachLine { line ->
            def bags = line.split(" contain ")
            def bagValue = (bags.first() =~ /^(.+?) bags?$/).with { matches() ? it[0][1] : NO_BAGS }
            bags.last().split(",").each { insideBag ->
                if (insideBag == NO_BAGS) {
                    mergeTo(bagMap, NO_BAGS, bags.first())
                } else {
                    def bagKey = (insideBag =~ /^.*?\d+ (.+?) bags?.*?$/).with { matches() ? it[0][1] : NO_BAGS }
                    mergeTo(bagMap, bagKey, bagValue)
                }
            }
        }

        println searchFor(bagMap, bagMap["shiny gold"]).size()
    }

    Set<String> searchFor(final Map<String, Set<String>> bagMap, final Set<String> keys) {
        if (keys == null || keys == Sets.newHashSet(NO_BAGS)) {
            return Sets.newHashSet()
        }

        def result = Sets.newHashSet(keys)
        keys.forEach { key -> result.addAll(searchFor(bagMap, bagMap[key])) }
        return result
    }

    def part2(final String input) {
        def bagMap = new HashMap<String, Set<SimpleEntry<String, Integer>>>()

        Puzzle7.class.getResourceAsStream(input).eachLine { line ->
            def bags = line.split(" contain ")
            def bagKey = (bags.first() =~ /^(.+?) bags?$/).with { matches() ? it[0][1] : NO_BAGS }
            bags.last().split(",").each { insideBag ->
                if (insideBag == NO_BAGS) {
                    mergeTo(bagMap, bags.first(), bagCount(NO_BAGS, 0))
                } else {
                    def bagValue = (insideBag =~ /^.*?(\d+) (.+?) bags?.*?$/).with {
                        matches() ? bagCount(it[0][2], it[0][1] as Integer) : bagCount(NO_BAGS, 0)
                    }
                    mergeTo(bagMap, bagKey, bagValue)
                }
            }
        }

        println countBags(bagMap, bagMap["shiny gold"])
    }

    Integer countBags(final Map<String, Set<SimpleEntry<String, Integer>>> bagMap, final Set<SimpleEntry<String, Integer>> bags) {
        if (bags == null || bags == bagCount(NO_BAGS, 0)) {
            return 1
        }

        def result = 0
        bags.forEach { bag -> result += bag.value + bag.value * countBags(bagMap, bagMap[bag.key]) }
        return result
    }

    static void main(String[] args) {
        new Puzzle7().part1("./puzzle7[input]")
        new Puzzle7().part2("./puzzle7[input]")
    }
}
