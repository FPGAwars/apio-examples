"""A python script to clean the examples projects.

Usage:
   python build_examples.py
"""

from pathlib import Path
import os
from glob import glob

# -- The examples root directory.
examples_dir = Path("examples").resolve()
assert examples_dir.is_dir(), examples_dir

for board in glob("*", root_dir=examples_dir):
    board_dir = examples_dir / board
    for example in glob("*", root_dir=board_dir):
       example_dir = board_dir / example  

       # -- Change to example directory.
       print(f"cd {example_dir}")
       os.chdir(example_dir)

       # -- Run 'apio clean'. We don't check the status.
       print(f"apio clean")
       os.system("apio clean")
