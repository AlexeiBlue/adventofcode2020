fs = require('fs')

lines = fs.readFileSync('puzzle16[input]').toString().split("\n\n").filter (x) -> x

rulesRaw = lines[0].split "\n"
rules = []

for rule in rulesRaw
    ruleSplit = rule.split ": "
    r = ruleSplit[1].split " or "
    first = r[0].split "-"
    second = r[1].split "-"
    rules.push {field: ruleSplit[0], from1: parseInt(first[0]), to1: parseInt(first[1]), from2: parseInt(second[0]), to2: parseInt(second[1])}


matchRule = (rule, value) ->
    return (value >= rule.from1 && value <= rule.to1) || (value >= rule.from2 && value <= rule.to2)

matchAtLeastOneRule = (value) ->
    for rule in rules
        if (matchRule(rule, value))
            return true
    return false

ourTicket = (lines[1].split('\n').filter (x) -> x)[1].split(',').map (x) -> parseInt(x)

nearbyTickets = lines[2].split('\n').filter (x) -> x
nearbyTickets.shift()
nearbyTickets = nearbyTickets.map (ticket) -> ticket.split(',').map (x) -> parseInt(x)

allTickets = [ourTicket]

sum = 0
for ticket in nearbyTickets
    valid = true
    for value in ticket
        if (!matchAtLeastOneRule(value))
            sum += value
            valid = false
    if (valid)
        allTickets.push(ticket)

console.log("Part 1: " + sum)

matches = []

for i in [0 .. ourTicket.length - 1]
    for rule in rules
        valid = true
        for ticket in allTickets
            if (!matchRule(rule, ticket[i]))
                valid = false
                break
        if (valid)
            matches.push({rule: rule.field, index: i})

filterMatches = (m) -> 
  if (m.rule == currentRule.rule)
    return m.index == currentRule.index
  return true

while (matches.length > rules.length)
    for i in [0 .. ourTicket.length - 1]
        rulesMatchingCurrentIndex = matches.filter (m) -> m.index == i

        if (rulesMatchingCurrentIndex.length == 1)
            currentRule = rulesMatchingCurrentIndex[0]
            matches = matches.filter (m) -> filterMatches(m)

departureFields = matches.filter (m) -> m.rule.startsWith('departure')

result = 1
for field in departureFields
    result *= ourTicket[field.index]

console.log("Part 2: " + result)