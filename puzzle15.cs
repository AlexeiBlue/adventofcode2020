using System;
using System.Collections.Generic;

namespace aoc {
	class puzzle15 {
    	static void Main() {
        	string input = System.IO.File.ReadAllText(@"puzzle15[input]");

			Console.Write("Part 1: {0}\n", getNumberSpokenAt(input, 2020));
			Console.Write("Part 2: {0}\n", getNumberSpokenAt(input, 30000000));
    	}

		static int getNumberSpokenAt(string input, int pos) {
			IDictionary<int, int> numbers = new Dictionary<int, int>();
			int i = 1;
			int previouslySaid = 0;

			foreach (string number in input.Split(',')) {
				numbers[Int32.Parse(number)] = i++;
				previouslySaid = Int32.Parse(number);
			}

			i--;
			numbers.Remove(previouslySaid);

			while (i < pos) {
				if (!numbers.ContainsKey(previouslySaid)) {
					numbers[previouslySaid] = i++;
					previouslySaid = 0;
				} else {
					int previousPos = numbers[previouslySaid];
					numbers[previouslySaid] = i;
					previouslySaid = i++ - previousPos;
				}
			}

			return previouslySaid;
		}
	}
}