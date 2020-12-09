preamble <- 25
input <- strtoi(readLines("./puzzle9[input]"))
firstInvalid <- 0
startFrom <- 1

isValid <- function(value) {
  i <- startFrom
  while (i < preamble + startFrom - 1) {
    j <- i + 1
    while (j < preamble + startFrom) {
      if (value == input[i] + input[j]) {
        return(TRUE)
      }
      j <- j + 1
    }
    i <- i + 1
  }
  return(FALSE)
}

for(value in tail(input, length(input) - preamble)) {
  if (isValid(value)) {
    startFrom <- startFrom + 1
    next
  }
  firstInvalid <- value
  break
}

# Part 1 answer
print(firstInvalid)

contiguousTo <- startFrom + preamble - 1

repeat {
  contiguousFrom <- contiguousTo

  while(firstInvalid > sum(input[contiguousFrom:contiguousTo])) {
    contiguousFrom = contiguousFrom - 1
  }

  if (firstInvalid == sum(input[contiguousFrom:contiguousTo])) {
    break
  }

  contiguousTo = contiguousTo - 1
}

# Part 2 answer
print(min(input[contiguousFrom:contiguousTo]) + max(input[contiguousFrom:contiguousTo]))
