"""A python script to clean the examples projects.

Usage:
   python clean_examples.py
"""

from pathlib import Path
from typing import List
import os
import examples_utils as utils

examples_root = Path(os.path.realpath("../examples"))
examples = utils.collect_examples(examples_root)

for example in examples:
    # -- Skip broken examples.
    if example in utils.KNOWN_BROKEN_EXAMPLEDS:
        continue

    # -- Change to the example dir.
    example_dir = examples_root / example
    print(f"\ncd {example_dir}")
    os.chdir(example_dir)

    # -- Run 'apio clean'
    print("apio clean")
    assert os.system("apio clean") == 0

    # -- Run 'apio build'
    print("apio build")
    assert os.system("apio build") == 0

    # -- Run 'apio clean'
    print("apio clean")
    assert os.system("apio clean") == 0
