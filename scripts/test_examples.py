"""A python script to test the examples projects.

Usage:
   python clean_examples.py
"""

from glob import glob
from pathlib import Path
import os
import examples_utils as utils

examples_root = Path(os.path.realpath("../examples"))
examples = utils.collect_examples(examples_root)

skipped_examples = []

for example in examples:
    # -- Skip known to be problematic examples.
    if example in utils.PROBLEMATIC_EXAMPLES:
        skipped_examples.append(example)
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

    # -- Run 'apio lint'
    # print("apio lint")
    # assert os.system("apio lint") == 0

    # -- Does the project has testbenches?
    if glob("*_tb.v"):

        # -- Run 'apio build'
        print("apio test")
        assert os.system("apio test") == 0

    # -- Run 'apio clean'
    print("apio clean")
    assert os.system("apio clean") == 0

print("\n\nSkipped problematic examples:")
for example in skipped_examples:
    print(f"- {example}")
print()

