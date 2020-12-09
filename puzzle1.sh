#!/bin/bash

IFS=$'\n'

IFS=$'\r\n' GLOBIGNORE='*' command eval  'INPUT=($(cat ./puzzle1[input]))'

for i in "${!INPUT[@]}"; do
    for j in "${!INPUT[@]}"; do
        for k in "${!INPUT[@]}"; do
            if [ "$i" != "$j" -a "$i" != "$k" -a "$j" != "$k" ]; then
                SUM=$(( ${INPUT[$i]} + ${INPUT[$j]} + ${INPUT[$k]} ))
                if [ "$SUM" == "2020" ]; then
                    printf "i = %s, j = %s, k = %s, sum = %s\n" "${INPUT[$i]}" "${INPUT[$j]}" "${INPUT[$k]}" "$(( ${INPUT[$i]} * ${INPUT[$j]} * ${INPUT[$k]} ))"
					break 3
                fi
            fi
        done
    done
done

