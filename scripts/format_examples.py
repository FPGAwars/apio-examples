#!/usr/bin/env python3

"""A python script that scans the entire examples tree and formats the
source files.

Do not run directly, run format_examples.py from repo's root.
"""

from pathlib import Path
import os
from pathlib import Path
import os
from glob import glob


examples_dir = Path("examples").resolve()
print(examples_dir)
assert examples_dir.is_dir(), examples_dir

for board_name in glob("*", root_dir=examples_dir):
    board_dir = examples_dir / board_name
    for example_name in glob("*", root_dir=board_dir):
        example_dir = board_dir / example_name
        print(f"*** Example {str(examples_dir)}")
        os.chdir(example_dir)
        status = os.system("apio format")
        assert status == 0, "Failed formatting"
