#!/bin/bash

# ILC 7 - Part 1
# Compare the text files and save their differences.

for n in 1 2 3 4
do
    folder="Testcase$n"
    output="Testcase${n}Diff"

    # Remove old results so running the script again gives the same result.
    rm -rf "$output"

    for first in "$folder"/*.1.txt
    do
        [ -f "$first" ] || continue
        second="${first%.1.txt}.2.txt"
        [ -f "$second" ] || continue

        if ! cmp -s "$first" "$second"
        then
            mkdir -p "$output"
            name="${first##*/}"
            name="${name%.1.txt}"
            diff -u "$first" "$second" > "$output/${name}Diff.txt"
        fi
    done
done
