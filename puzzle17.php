<?php
$zOffsets = array(
    array(-1, true), 
    array(0, false), 
    array(1, true)
);

$sliceOffsets = array(
    array(-1, -1),
    array(-1, 0),
    array(-1, 1),
    array(0, 1),
    array(1, 1),
    array(1, 0),
    array(1, -1),
    array(0, -1)
);

function readInput() {
    $file = fopen("puzzle17[input]", "r");
    $input = array();
    while (!feof($file)) {
        $input[] = str_split(trim(fgets($file)));
    }
    fclose($file);

    $result = array(
        array_fill(
            0, 
            count($input),
            array_fill(0, count($input), ".")
        ),
        $input,
        array_fill(
            0, 
            count($input),
            array_fill(0, count($input), ".")
        )
    );

    return $result;
}

function cycle($array, $zOffsets, $sliceOffsets, $increaseBy) {
    $newArray = array_fill(
        0, 
        count($array) + $increaseBy, 
        array_fill(
            0, 
            count($array[0]) + $increaseBy, 
            array_fill(0, count($array[0][0]) + $increaseBy, ".")
        )
    );

    for ($z = 0; $z < count($newArray); $z++) {
        for ($y = 0; $y < count($newArray[0]); $y++) {
            for ($x = 0; $x < count($newArray[0][0]); $x++) {
                $result = activeNeighbors($x, $y, $array, $zOffsets, $sliceOffsets);

                if ($array[$z][$y][$x] == "#") {
                    if ($result == 2 || $result == 3) {                        
                        $newArray[$z][$y][$x] = "#";
                    }
                } else {
                    if ($result == 3) {
                        $newArray[$z][$y][$x] = "#";
                    }
                }
            }
        }
    }

    return $newArray;
}

function activeNeighbors($x, $y, $array, $zOffsets, $sliceOffsets) {
    $result = 0;
    foreach ($zOffsets as $offset) {
        $result += activeNeighborsInSlice($x, $y, $offset[1], $array[$offset[0]], $sliceOffsets);
    }
    return $result;
}

function activeNeighborsInSlice($x, $y, $checkXY, $array, $sliceOffsets) {
    $result = 0;
    foreach ($sliceOffsets as $offset) {
        if ($y + $offset[0] >= 0 && $y + $offset[0] < count($array) && $x + $offset[1] >= 0 && $x + $offset[1] < count($array[$y])) {
            if ($array[$y + $offset[0]][$x + $offset[1]] == "#") {
                $result++;
            }
        }
    }
    
    if ($checkXY && $array[$y][$x] == "#") {
        $result++;
    }

    return $result;
}

function printArray($array) {
    echo "Printing cubes\n\n";
    foreach ($array as $z) {
        echo "zzzzzzzzzzzzzzzzzzzz\n";
        foreach ($z as $y) {
            foreach ($y as $x) {
                echo $x;
            }
            echo "\n";
        }
    }
}

$input = readInput();
for ($cycle = 0; $cycle < 6; $cycle++) {
    printArray($input);
    $input = cycle($input, $zOffsets, $sliceOffsets, $cycle);
}

$result = 0;
for ($z = 0; $z < count($input); $z++) {
    for ($y = 0; $y < count($input[0]); $y++) {
        for ($x = 0; $x < count($input[0][0]); $x++) {
            if ($input[$z][$y][$x] == "#") {
                $result++;
            }
        }
    }
}

echo "Part 1: " . strval($result);
?>