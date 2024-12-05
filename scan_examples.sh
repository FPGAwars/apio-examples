#!/bin/bash

# A shell script that scans the examples for various issues.

rm -f _boards_report.csv _examples_report.csv

python scripts/scan_examples.py

