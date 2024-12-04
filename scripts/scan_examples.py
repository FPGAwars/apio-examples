"""A python script that scans the entire examples tree for 
various issues.

Usage:
   python scan_examples.py
"""

from pathlib import Path
import os
from apio.apio_context import ApioContext
from examples_utils import scan_examples_tree, BoardIssues, ExampleIssues


examples_root = Path(os.path.realpath("../examples"))

board_scans = scan_examples_tree(examples_root)

# apio_ctx = ApioContext(load_project=False)
# # os.chdir("../examples")
# for b in board_scans:
#     board = b.name
#     board_id = apio_ctx.lookup_board_id(board)
#     if board != board_id:
#         print(f'mv ""{board} "{board_id}"')

    
# -- Print boards table header.
header = ["board"]
for issue in BoardIssues:
    header.append(issue.name)
print(",".join(header))

# -- Print board values
for b in board_scans:
    issues = [x.name for x in b.issues]
    values = [b.name]
    for issue in BoardIssues:
         if issue in b.issues:
            values.append("X")
         else: values.append("")
    print (",".join(values))






# print()
# print(f"Board : {b.name}")
# if issues:
#    print(f"Issues: {issues}")
# for e in b.examples:
#    issues = [x.name for x in e.issues]
#    print()
#    print(f"   Example: {e.name}")
#    if issues:
#       print(f"   Issues : {issues}")
    





