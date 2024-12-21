"""A python script that scans the entire examples tree for 
various issues.

Do not run directly, run scan_examples.py from repo's root.
"""

from pathlib import Path
from enum import Enum
from dataclasses import dataclass
import os
from apio.apio_context import ApioContext

# from examples_utils import scan_examples_tree, BoardIssues, ExampleIssues
from typing import Set, List, Union
from pathlib import Path
import os
from glob import glob
import re
import click


class BoardIssues(Enum):
    """Ids of examples board level issues."""

    MISSING_DIR = 1
    BAD_DIR_NAME = 2
    NO_TEMPLATE = 3
    EMPTY_DIR = 4


class ExampleIssues(Enum):
    """Ids of examples example level issues."""

    BAD_DIR_NAME = 1
    BOARD_MISMATCH = 2
    NO_INFO = 3
    NO_APIO_INI = 4
    BAD_APIO_INI = 5
    BUILD_FAILS = 6
    LINT_FAILS = 7
    NO_TESTBENCH = 8
    TEST_FAILS = 9
    MISSING_VCD = 10
    MISSING_GTKW = 11
    CLEAN_FAILS = 12
    INFO_TOO_LONG = 13
    INFO_TOO_SHORT = 14
    MULTIPLE_INFO_LINES = 15
    CONTAINS_DIRS = 16
    HAS_DUMPFILE = 17
    HAS_VCD_OUTPUT = 18
    GRAPH_FAILS = 19
    


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

    @property
    def full_name(self):
        return f"{self.board.name}/{self.name}"


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


def scan_board_issues(board_name: str, board_dir: Path) -> Set[BoardIssues]:

    print(f"\n\n***** BOARD {board_dir}\n")

    apio_ctx = ApioContext(load_project=False)

    # -- Create an empty test to collect the issues.
    issues: Set[BoardIssues] = set()

    # -- Test that the name is a valid board name
    if board_name != apio_ctx.lookup_board_id(
        board_name, strict=False, warn=False
    ):
        issues.add(BoardIssues.BAD_DIR_NAME)

    # -- Test if an example named 'template' exists.
    if not (board_dir / "template").is_dir():
        issues.add(BoardIssues.NO_TEMPLATE)

    # -- Test if it has at least one example.
    if not glob("*", root_dir=board_dir):
        issues.add(BoardIssues.EMPTY_DIR)

    return issues


example_name_regex = re.compile(r"^[a-z][a-z0-9-]*$")


def scan_example_issues(
    example_name: str, example_dir: Path
) -> Set[ExampleIssues]:

    save_dir = Path().absolute()

    print(f"\n\n***** EXAMPLE {example_dir}\n")

    # -- Change to example dir
    print(f"cd {example_dir}")
    os.chdir(example_dir)

    # -- Create an apio context for this project.
    apio_ctx = ApioContext(load_project=True)

    # -- Create an empty test to collect the issues.
    issues: Set[ExampleIssues] = set()

    # -- Test if the name matches the regex.
    if not example_name_regex.match(example_name):
        print(f"BAD_EXAMPLE_NAME: [{example_name}]")
        issues.add(ExampleIssues.BAD_DIR_NAME)

    # -- Test if cleans ok.
    if run("apio clean") != 0:
        issues.add(ExampleIssues.CLEAN_FAILS)

    # -- Tests if it builds ok.
    if run("apio build") != 0:
        issues.add(ExampleIssues.BUILD_FAILS)

    # -- Tests if lints ok.
    if run("apio lint") != 0:
        issues.add(ExampleIssues.LINT_FAILS)

    # -- Tests if graphs ok
    if run("apio graph") != 0:
        issues.add(ExampleIssues.GRAPH_FAILS)
    if not Path("_build/hardware.dot").is_file():
        issues.add(ExampleIssues.GRAPH_FAILS)
    if not Path("_build/hardware.svg").is_file():
        issues.add(ExampleIssues.GRAPH_FAILS)


    # -- If there are testbenches, test them.
    testbenches = glob("*_tb.v") + glob("*_tb.sv")
    for tb in testbenches:
        # -- Each testbench should have a matching .gtkw file with signal
        # -- selection for 'apio sim' gtkwave view.
        gtkw_file_name = os.path.splitext(tb)[0] + ".gtkw"
        if not Path(gtkw_file_name).is_file():
            issues.add(ExampleIssues.MISSING_GTKW)
    if not testbenches:
        issues.add(ExampleIssues.NO_TESTBENCH)
    elif run("apio test") != 0:
        issues.add(ExampleIssues.TEST_FAILS)
    else:
        # Test passed. Verify that each testbench generated the expected .vcd.
        for tb in testbenches:
            vcd_file_name = os.path.splitext(tb)[0] + ".vcd"
            expected_vcd = Path("_build") / vcd_file_name
            if not expected_vcd.is_file():
                issues.add(ExampleIssues.MISSING_VCD)

    # -- Check a few requirements from teh apio.ini file.
    if not (example_dir / "apio.ini").is_file():
        issues.add(ExampleIssues.NO_APIO_INI)
    elif not apio_ctx.project:
        issues.add(ExampleIssues.BAD_APIO_INI)
    elif not apio_ctx.project["board"] or not apio_ctx.project["top-module"]:
        issues.add(ExampleIssues.BAD_APIO_INI)
    elif apio_ctx.project["board"] != apio_ctx.lookup_board_id(
        apio_ctx.project["board"], warn=False, strict=False
    ):
        issues.add(ExampleIssues.BAD_APIO_INI)

    # -- Check a few requirements from the info file.
    if not (example_dir / "info").is_file():
        issues.add(ExampleIssues.NO_INFO)
    else:
        info_lines = read_lines("info")
        if len(info_lines) != 1:
            issues.add(ExampleIssues.MULTIPLE_INFO_LINES)
        if len(info_lines[0]) < 10:
            issues.add(ExampleIssues.INFO_TOO_SHORT)
        elif len(info_lines[0]) > 100:
            issues.add(ExampleIssues.INFO_TOO_LONG)

    # -- Check that the project doesn't contains subdirectoreis. This
    # -- creates an issue with 'apio examples -f".
    run("apio clean")
    for e in glob("*"):
        if (example_dir / e).is_dir():
            issues.add(ExampleIssues.CONTAINS_DIRS)

    # -- If the project has a project file (it should) check that its
    # -- 'board' value equals the parent example directory name.
    board_name = os.path.basename(example_dir.parent)
    if apio_ctx.project and apio_ctx.project["board"] != board_name:
        issues.add(ExampleIssues.BOARD_MISMATCH)

    # -- Check if a testbench contains '$dumpfile'
    if os.system("grep '$dumpfile(' *_tb.v") == 0:
        issues.add(ExampleIssues.HAS_DUMPFILE)
    if os.system("grep '$dumpfile(' *_tb.sv") == 0:
        issues.add(ExampleIssues.HAS_DUMPFILE)

    # -- Check if a testbench contains 'VCD_OUTPUT'
    if os.system("grep VCD_OUTPUT *_tb.v") == 0:
        issues.add(ExampleIssues.HAS_VCD_OUTPUT)
    if os.system("grep VCD_OUTPUT *_tb.sv") == 0:
        issues.add(ExampleIssues.HAS_VCD_OUTPUT)

    # Restore caller's cwd.
    os.chdir(save_dir)

    # All done.
    return issues


def report_boards(file_name: str, issues_only: bool):

    # -- Collect the boards issues that shoule be included in the report.
    boards_to_show = set()
    issues_to_show = set()
    if issues_only:
        for b in boards_scans:
            if b.issues:
                boards_to_show.add(b.name)
            issues_to_show.update(b.issues)
    else:
        boards_to_show.update([b.name for b in boards_scans])
        issues_to_show.update([i for i in BoardIssues])

    # -- Write the report
    with open(file_name, "w") as f:

        # -- Print boards table header.
        header = ["BOARD"]
        for issue in BoardIssues:
            if issue not in issues_to_show:
                continue
            header.append(issue.name.replace("_", " "))
        f.write(",".join(header) + "\n")

        # # -- Print board values
        for b in boards_scans:
            if b.name not in boards_to_show:
                continue
            values = [b.name]
            for issue in BoardIssues:
                if issue not in issues_to_show:
                    continue
                if issue in b.issues:
                    values.append("X")
                else:
                    values.append(" ")
            f.write(",".join(values) + "\n")

        click.secho(f"Generated {file_name}", fg="green")


def report_examples(file_name: str, issues_only: bool):

    # -- Collect the examples and issues that shoule be included
    # -- in the report.
    examples_to_show = set()
    issues_to_show = set()
    if issues_only:
        for e in examples_scans:
            if e.issues:
                examples_to_show.add(e.full_name)
            issues_to_show.update(e.issues)
    else:
        examples_to_show.update(e.full_name for e in examples_scans)
        issues_to_show.update([i for i in ExampleIssues])

    with open(file_name, "w") as f:
        # -- Print boards table header.
        header = ["BOARD", "EXAMPLE"]
        for issue in ExampleIssues:
            if issue not in issues_to_show:
                continue
            header.append(issue.name.replace("_", " "))
        f.write(",".join(header) + "\n")

        # # -- Print board values
        for e in examples_scans:
            if e.full_name not in examples_to_show:
                continue
            #   issues = [x.name for x in b.issues]
            values = [e.board.name, e.name]
            for issue in ExampleIssues:
                if issue not in issues_to_show:
                    continue
                if issue in e.issues:
                    values.append(f"X")
                else:
                    values.append(f" ")
            f.write(",".join(values) + "\n")

        click.secho(f"Generated {file_name}", fg="green")


# -- MAIN starts here

# -- The examples root directory.
examples_dir = Path("examples").resolve()
print(examples_dir)
assert examples_dir.is_dir(), examples_dir

boards_scans: List[BoardScan] = []
examples_scans: List[ExampleScan] = []

# -- Scan boards and examples. Results are in boards_scan and examples_scan
# -- respectivly.
for board_name in glob("*", root_dir=examples_dir):
    board_dir = examples_dir / board_name
    board_issues = scan_board_issues(board_name, board_dir)
    board_scan = BoardScan(board_name, board_dir, board_issues, [])
    boards_scans.append(board_scan)

    for example_name in glob("*", root_dir=board_dir):
        example_dir = board_dir / example_name
        examples_issues = scan_example_issues(example_name, example_dir)
        example_scan = ExampleScan(
            example_name, board_scan, example_dir, examples_issues
        )
        board_scan.examples.append(example_scan)
        examples_scans.append(example_scan)

print("\n\n**** scan done.\n")

# -- Append entries for supported boards that don't have a directory.
boards_with_dirs = [b.name for b in boards_scans]
apio_ctx = ApioContext(load_project=False)
for b in apio_ctx.boards:
    if b not in boards_with_dirs:
        board_scan = BoardScan(b, None, set([BoardIssues.MISSING_DIR]), [])
        boards_scans.append(board_scan)

# -- Sort by names
boards_scans.sort(key=lambda b: b.name)
examples_scans.sort(key=lambda e: (e.board.name, e.name))


print("\n\n**** sgenerating files.\n")

# -- Generate for boards
report_boards("_boards_full.csv", issues_only=False)
report_boards("_boards_issues_only.csv", issues_only=True)

# -- Generate for examples
report_examples("_examples_full.csv", issues_only=False)
report_examples("_examples_issues_only.csv", issues_only=True)
