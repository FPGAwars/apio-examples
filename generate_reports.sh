#!/bin/bash

# A shell script that generate reports.

rm -f _boards_full.csv _boards_issues_only.csv
rm -f _examples_full.csv _examples_issues_only.csv

python scripts/generate_reports.py

