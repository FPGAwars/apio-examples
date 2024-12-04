from pathlib import Path
from typing import List
import os
import re
from glob import glob
from enum import Enum
from dataclasses import dataclass
from typing import Set, List, Union
from apio.apio_context import ApioContext


class BoardIssues(Enum):
    """Ids of examples board level issues."""

    BAD_NAME = 1
    NO_TEMPLATE = 2
    NO_EXAMPLES = 6


class ExampleIssues(Enum):
    """Ids of examples example level issues."""

    BAD_NAME = 1
    BUILD_FAILS = 2
    LINT_FAILS = 3
    TEST_FAILS = 4
    NO_TESTBENCH = 5
    NO_APIO_INI = 6
    BAD_APIO_INI = 7
    NO_INFO = 8
    DESCRIPTION_TOO_LONG = 9
    DESCRIPTION_TOO_SHORT = 10
    CLEAN_FAILS = 13
    MULTIPLE_INFO_LINES = 14


@dataclass
class BoardScan:
    name: str
    board_dir: Path
    issues: Set[BoardIssues]
    examples: List["ExampleScan"]


@dataclass
class ExampleScan:
    name: str
    board: BoardScan
    example_dir: Path
    issues: Set[ExampleIssues]


def run(cmd: str) -> int:
    print(f"{cmd}")
    return os.system(cmd)


def read_lines(file: Union[str, Path]) -> List[str]:
    """Read the file, return a list of its lines rstrip'ed.."""
    # -- Read the lines.
    with open(file, "r", encoding="utf8") as f:
        lines = f.readlines()
    # -- rstrip() the lines.
    lines = [l.rstrip() for l in lines]
    return lines


def collect_board_names(examples_dir: Path) -> List[str]:
    """Scan the given directory and return the list of board names."""
    dir_entries = os.listdir(examples_dir)
    # -- Select the entries that don't start with "." and are directories.
    board_names = [
        e
        for e in dir_entries
        if (e[0] not in ".") and (examples_dir / e).is_dir()
    ]
    return board_names


def collect_example_names(board_dir: Path) -> List[str]:
    # -- Get dir entries.
    dir_entries = os.listdir(board_dir)
    # -- Select entries that don't start with "." and are directoreis.
    example_names = [
        e
        for e in dir_entries
        if (e[0] not in ".") and (board_dir / e).is_dir()
    ]
    return example_names


# board_name_regex = re.compile(r"^[a-z][a-z0-9_-]*$")


def scan_board_issues(board_name: str, board_dir: Path) -> Set[BoardIssues]:

    print(f"\n\n***** {board_dir}\n")

    apio_ctx = ApioContext(load_project=False)

    # -- Create an empty test to collect the issues.
    issues: Set[BoardIssues] = set()

    # -- Test that the name is a valid board name
    if board_name != apio_ctx.lookup_board_id(board_name):
        issues.add(BoardIssues.BAD_NAME)

    # -- Test if an example named 'template' exists.
    if not (board_dir / "template").is_dir():
        issues.add(BoardIssues.NO_TEMPLATE)

    # -- Test if it has at least one example.
    if not collect_example_names(board_dir):
        issues.add(BoardIssues.NO_EXAMPLES)

    return issues


example_name_regex = re.compile(r"^[a-z][a-z0-9_-]*$")


def scan_example_issues(
    example_name: str, example_dir: Path
) -> Set[ExampleIssues]:
    
    print(f"\n\n***** {example_dir}\n")

    # -- Change to example dir
    print(f"cd {example_dir}")
    os.chdir(example_dir)

    # -- Create an apio context for this project.
    apio_ctx = ApioContext(load_project=True)

    # -- Create an empty test to collect the issues.
    issues: Set[ExampleIssues] = set()

    # -- Test if the name matches the regex.
    if not example_name_regex.match(example_name):
        issues.add(ExampleIssues.BAD_NAME)

    # -- Test if cleans ok.
    if run("apio clean") != 0:
        issues.add(ExampleIssues.CLEAN_FAILS)

    # -- Tests if it builds ok.
    if run("apio build") != 0:
        issues.add(ExampleIssues.BUILD_FAILS)

    # -- Tests if lints ok.
    if run("apio lint") != 0:
        issues.add(ExampleIssues.LINT_FAILS)

    # -- If there are testbenches, test them.
    if not glob("*_tb.v"):
        issues.add(ExampleIssues.NO_TESTBENCH)
    elif run("apio test") != 0:
        issues.add(ExampleIssues.TEST_FAILS)

    # -- Check apio_ini
    if not (example_dir / "apio.ini").is_file():
        issues.add(ExampleIssues.NO_APIO_INI)
    elif not apio_ctx.project:
        issues.add(ExampleIssues.BAD_APIO_INI)
    elif not apio_ctx.project["board"] or not apio_ctx.project["top-module"]:
        issues.add(ExampleIssues.BAD_APIO_INI)
    elif apio_ctx.project["board"] != apio_ctx.lookup_board_id(
        apio_ctx.project["board"]
    ):
        issues.add(ExampleIssues.BAD_APIO_INI)

    # -- Check info
    if not (example_dir / "info").is_file():
        issues.add(ExampleIssues.NO_INFO)
    else:
        info_lines = read_lines("info")
        if len(info_lines) != 1:
            issues.add(ExampleIssues.MULTIPLE_INFO_LINES)
        if len(info_lines[0]) < 10:
            issues.add(ExampleIssues.DESCRIPTION_TOO_SHORT)
        elif len(info_lines[0]) > 100:
            issues.add(ExampleIssues.DESCRIPTION_TOO_LONG)

    return issues


def scan_examples_tree(examples_root: Path) -> List[BoardScan]:
    """Scan the entire examples tree, including boarads and examples
    and return the results as a list of BoardScan."""
    board_scans: List[BoardScan] = []

    for board_name in collect_board_names(examples_root):
        board_dir = examples_root / board_name
        board_issues = scan_board_issues(board_name, board_dir)
        board_scan = BoardScan(
            name=board_name,
            board_dir=examples_root / board_name,
            issues=board_issues,
            examples=[],
        )
        board_scans.append(board_scan)

        for example_name in collect_example_names(board_dir):
            example_dir = board_dir / example_name
            example_issues = scan_example_issues(example_name, example_dir)
            example_scan = ExampleScan(
                name=example_name,
                board=board_scan,
                example_dir=example_dir,
                issues=example_issues,
            )
            board_scan.examples.append(example_scan)

    return board_scans
