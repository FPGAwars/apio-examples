#!/bin/bash

# A shell script that scans the examples for various issues.

rm -f _boards_full.csv _boards_issues_only.csv
rm -f _examples_full.csv _examples_issues_only.csv

python scripts/scan_examples.py

