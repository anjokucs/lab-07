#!/bin/bash

# ILC 7 - Part 2
# Check the diff results without changing any files.

all_pass=1

for n in 1 2 3 4
do
    folder="Testcase$n"
    output="Testcase${n}Diff"
    passed=1
    differences=0

    for first in "$folder"/*.1.txt
    do
        [ -f "$first" ] || continue
        second="${first%.1.txt}.2.txt"
        [ -f "$second" ] || continue

        name="${first##*/}"
        name="${name%.1.txt}"
        result="$output/${name}Diff.txt"

        if cmp -s "$first" "$second"
        then
            # Matching pairs should not have a diff file.
            if [ -f "$result" ]
            then
                passed=0
            fi
        else
            differences=1

            if [ ! -f "$result" ]
            then
                passed=0
            elif ! cmp -s <(diff -u "$first" "$second" | tail -n +3) <(tail -n +3 "$result")
            then
                # Skip the two diff headers because timestamps can change.
                passed=0
            fi
        fi
    done

    # Only testcases with differences should have a Diff directory.
    if [ "$differences" -eq 1 ] && [ ! -d "$output" ]
    then
        passed=0
    fi

    if [ "$differences" -eq 0 ] && [ -d "$output" ]
    then
        passed=0
    fi

    if [ "$passed" -eq 1 ]
    then
        echo "Testcase$n: PASS"
    else
        echo "Testcase$n: FAIL"
        all_pass=0
    fi
done

if [ "$all_pass" -eq 1 ]
then
    exit 0
else
    exit 1
fi
