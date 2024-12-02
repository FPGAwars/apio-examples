"""A python script that scans the entire examples tree for 
various issues.

Usage:
   python scan_examples.py
"""

from pathlib import Path
import os
from examples_utils import scan_examples_tree


examples_root = Path(os.path.realpath("../examples"))

board_scans = scan_examples_tree(examples_root)

for b in board_scans:
    issues = [x.name for x in b.issues]
    print()
    print(f"Board : {b.name}")
    if issues:
       print(f"Issues: {issues}")
    for e in b.examples:
        issues = [x.name for x in e.issues]
        print()
        print(f"   Example: {e.name}")
        if issues:
            print(f"   Issues : {issues}")
    





