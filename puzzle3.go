package main

import (
	"bufio"
	"fmt"
	"os"
)

func appendInput(path string, skiMap [][]byte) ([][]byte, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	index := 0
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		if len(skiMap) == index {
			skiMap = append(skiMap, make([]byte, 0))
		}

		skiMap[index] = append(skiMap[index], []byte(scanner.Text())...)
		index++
	}
	return skiMap, scanner.Err()
}

func skiFrom(skiMap [][]byte, right int, down int, x int, y int, trees int) (int, int, int) {
	for {
		if y >= len(skiMap) || x >= len(skiMap[0]) {
			return x, y, trees
		}

		if skiMap[y][x] == byte('#') {
			trees++
		}

		x += right
		y += down
	}
}

func checkSlope(right int, down int) int {
	var err error

	skiMap := make([][]byte, 0)
	y := 0
	x := 0
	trees := 0

	for {
		skiMap, err = appendInput("./puzzle3[input]", skiMap)
		if err != nil {
			panic(err)
		}

		x, y, trees = skiFrom(skiMap, right, down, x, y, trees)
		if y >= len(skiMap) {
			return trees
		}
	}
}

func main() {
	results := make([]int, 0)

	results = append(results, checkSlope(1, 1))
	results = append(results, checkSlope(3, 1))
	results = append(results, checkSlope(5, 1))
	results = append(results, checkSlope(7, 1))
	results = append(results, checkSlope(1, 2))

	result := 1

	for _, m := range results {
		result *= m
	}

	fmt.Printf("%v", result)
}
