import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Stream;

import static java.util.stream.Collectors.toSet;

public class Puzzle6 {
    /* Pinched from https://codereview.stackexchange.com/a/145605 */
    public static <T, C extends Collection<T>> Collection<T> intersect(Stream<C> stream) {
        final Iterator<C> allLists = stream.iterator();

        if (!allLists.hasNext()) return Collections.emptySet();

        final Set<T> result = new HashSet<>(allLists.next());
        allLists.forEachRemaining(result::retainAll);
        return result;
    }

    private static Stream<Set<Integer>> answersToSetStream(final String group) {
        return Arrays.stream(group.split("\n")).map(answers -> answers.chars().boxed().collect(toSet()));
    }

    private void run() throws IOException, URISyntaxException {
        final Path input = Path.of(Puzzle6.class.getResource("./puzzle6[input]").toURI());

        System.out.println(
                Arrays.stream(Files.readString(input).split("\n\n"))
                        .map(group -> intersect(answersToSetStream(group)).size())
                        .reduce(0, Integer::sum)
        );
    }

    public static void main(String [] args) throws IOException, URISyntaxException { new Puzzle6().run(); }
}
