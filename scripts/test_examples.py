"""A python script to test the examples in the examples repo.
Run it at the root directory of the repo. It exist with an 
error status code on the first error it detects.
"""

import sys
import re
import os
from pathlib import Path
import subprocess
import configparser
from glob import glob
from subprocess import CompletedProcess
from typing import List, Union

# -- Examples repo top dir.
REPO_DIR = Path(".").absolute()

# -- The examples dir with the boards.
EXAMPLES_DIR = REPO_DIR / "examples"

# Valid format of board and example names.
NAME_REGEX = r"^[a-z][a-z0-9-]*$"


def read_file_lines(file: Union[str, Path]) -> List[str]:
    """Read the file, return a list of its lines rstrip'ed.."""
    with open(file, "r", encoding="utf8") as f:
        lines = f.readlines()
    lines = [l.rstrip("\r\n") for l in lines]
    return lines


def run_cmd(cmd: List[str], check: bool = False) -> CompletedProcess:
    """Run a given system command. If check = True, also assert that
    it returned an OK status code."""

    print(f"Run: {cmd}")
    result = subprocess.run(cmd, text=True, capture_output=True, check=False)
    if check and result.returncode != 0:
        print(f"Command failed: {result.returncode}")
        print(f"STDOUT: {result.stdout}")
        print(f"STDERR: {result.stderr}")
        sys.exit(1)
    return result


def test_example_info_file(info_file: Path):
    """Verify an example info file."""

    # -- Read the lines of the info file.
    info_lines = read_file_lines(info_file)

    # -- Should have exactly one line
    assert len(info_lines) == 1, "Info file should have exactly one lind."

    # -- Check the info line.
    info_line = info_lines[0]
    assert len(info_line) >= 10, "Info line is too short"
    assert len(info_line) <= 100, "Info line is too long"
    assert info_line == info_line.strip(), "Info line has leading or trailing spaces "


def test_testbench_output(env_name: str, testbench: str) -> Path:
    """Assert that the testbench output files exist.."""
    vcd = os.path.splitext(testbench)[0] + ".vcd"
    vcd_path = Path("_build") / env_name / vcd
    assert vcd_path.is_file(), f"Missing vcd file {vcd_path}"

    out = os.path.splitext(testbench)[0] + ".out"
    out_path = Path("_build") / env_name / out
    assert out_path.is_file(), f"Missing out file {out_path}"


def test_example_env(
    board_name: str, example_name: str, env_name: str, testbenches: List[str]
) -> None:
    """Test the given env of an example."""

    print(f"\nENV: {board_name}/{example_name}:{env_name}")

    example_dir = EXAMPLES_DIR / board_name / example_name
    os.chdir(example_dir)

    run_cmd(["apio", "build", "-e", env_name], check=True)
    run_cmd(["apio", "lint", "-e", env_name], check=True)
    run_cmd(["apio", "graph", "-e", env_name], check=True)
    run_cmd(["apio", "report", "-e", env_name], check=True)

    # -- Test 'apio test'
    if testbenches:
        run_cmd(["apio", "clean"])
        run_cmd(["apio", "test", "-e", env_name], check=True)
        for testbench in testbenches:
            test_testbench_output(env_name, testbench)

    # -- Test 'apio sim' (default testbench)
    if testbenches:
        run_cmd(["apio", "clean"])
        run_cmd(["apio", "sim", "--no-gtkwave"])

    # -- Test apio sim with individual testbenches
    if testbenches:
        run_cmd(["apio", "clean"])
        for testbench in testbenches:
            run_cmd(
                ["apio", "sim", "--no-gtkwave", "-e", env_name, testbench], check=True
            )
            test_testbench_output(env_name, testbench)

    # -- Test format.
    run_cmd(["apio", "format", "-e", env_name], check=True)


def test_example(board_name: str, example_name: str) -> None:
    """Test an example."""

    print(f"\nEXAMPLE: {board_name}/{example_name}")

    assert re.match(NAME_REGEX, example_name), f"Invalid example name {example_name}"

    example_dir = EXAMPLES_DIR / board_name / example_name
    os.chdir(example_dir)

    # -- Test the 'info file'.
    test_example_info_file(example_dir / "info")

    # -- Read apio.ini
    apio_ini = configparser.ConfigParser()
    apio_ini.read("apio.ini")

    # -- Get list of project envs
    sections = apio_ini.sections()
    env_names = [s.split(":", 1)[1] for s in sections if s.startswith("env:")]
    assert len(env_names) > 0, sections

    # -- Assert that all 'board = x' match the board name.
    for section in apio_ini.sections():
        if "board" in apio_ini[section]:
            board_val = apio_ini[section]["board"]
            assert board_val == board_name

    # -- Get list of testbenches, relative to project root.
    testbenches = list(Path(".").rglob("*_tb.v")) + list(Path(".").rglob("*_tb.sv"))
    testbenches = [str(t) for t in testbenches]

    # -- Check the testbenches files, without running them yet.
    for testbench in testbenches:
        # -- Assert the testbench doesn't contain $dumpfile() or VCD_OUTPUT
        with open(testbench, "r", encoding="utf-8") as f:
            content = f.read()
        assert "$dumpfile(" not in content, f"$dumpfile() found in {testbench}"
        assert "VCD_OUTPUT" not in content, f"VCD_OUTPUT found in {testbench}"

        # -- Assert testbench has a GTKW signals save files.
        gtkw_file = Path(testbench).with_suffix(".gtkw")
        assert gtkw_file.is_file(), f"Missing .gtkw file for testbench {testbench}"

    # -- Test each env
    for env_name in env_names:
        test_example_env(board_name, example_name, env_name, testbenches)

    os.chdir(example_dir)
    run_cmd(["apio", "clean"], check=True)


def test_board(board_name: str) -> None:
    """Test board's examples."""

    print("\n--------------------------")
    print(f"\nBOARD: {board_name}")

    assert re.match(NAME_REGEX, board_name), f"Invalid example name {board_name}"

    board_dir = EXAMPLES_DIR / board_name
    os.chdir(board_dir)

    example_names = glob("*", root_dir=board_dir)
    example_names = sorted(example_names)
    assert len(example_names) > 0, f"Board dir '{board_name}' has no examples"

    for example_name in example_names:

        example_dir = board_dir / example_name
        assert (
            example_dir.is_dir()
        ), f"Example {board_name}/{example_name} is not a dir."
        test_example(board_name, example_name)


def main() -> None:
    """Main."""

    print("Examples repo test.")
    print()
    print(f"{REPO_DIR=}")
    print(f"{EXAMPLES_DIR=}")

    # -- Get names of boards with examples.
    board_names = glob("*", root_dir=EXAMPLES_DIR)
    board_names = sorted(board_names)
    assert len(board_names) > 20, f"Found too few boards: {board_names}"

    # -- Test each of the boards.
    for board_name in board_names:
        board_dir = EXAMPLES_DIR / board_name
        assert board_dir.is_dir(), f"Board dir is not a dir: {board_dir}"
        # -- This may call chdir().
        test_board(board_name)


if __name__ == "__main__":
    main()
