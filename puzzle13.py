def next_depart_time(arrival, bus):
    departTime = arrival
    while True:
        if departTime % bus == 0:
            return departTime
        departTime += 1


def partOne(lines):
    arrival = int(lines[0])
    buses = map(int, filter(lambda bus: bus != "x", lines[1].split(",")))

    nearestDepartTime = arrival
    busId = 0

    for bus in buses:
        departTime = next_depart_time(arrival, bus)
        if nearestDepartTime == arrival or nearestDepartTime > departTime:
            nearestDepartTime = departTime
            busId = bus

    return str(busId * (nearestDepartTime - arrival))


def hasStaggedDepartures(busSlots, timestamp):
    for slot in busSlots:
        if slot != "x" and timestamp % int(slot) != 0:
            return False
        timestamp += 1
    return True


# Copied from https://www.reddit.com/r/adventofcode/comments/kc4njx/2020_day_13_solutions/gfray8m/?utm_source=reddit&utm_medium=web2x&context=3
# Uses Chinese Remainder Theorem which is a bit over my head
# From what I understand the bus slots are mapped to an int list where x is replaced by zero, 
# the bus numbers are all prime numbers and when sorted they become co-prime numbers,
# and that's where I get lost...
def partTwo(lines):
    buses = map(int, lines[1].replace("x", "0").split(","))
    indices = [i for i, bus in enumerate(buses) if bus]
    diff = indices[-1] - indices[0]
    prod = reduce(lambda a, b: a * b, filter(None, buses))
    return str(
        sum((diff - i) * pow(prod // n, n - 2, n) * prod // n
            for i, n in enumerate(buses) if n) % prod - diff
    )

file1 = open('puzzle13[input]', 'r')
lines = file1.readlines()

print("Part 1: " + partOne(lines))
print("Part 2: " + partTwo(lines))
