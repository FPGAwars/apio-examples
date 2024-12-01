from pathlib import Path
from typing import List
import os

# -- Examples that are known to be problematic.
PROBLEMATIC_EXAMPLES = [
    # -- Non buildable pcf examples.
    "icezum/pcf",
    "icoboard/pcf",
    "go-board/pcf",
    "icestick/pcf",
    "kefir/pcf",
    # -- Non standard structure, relies on custom
    # -- SCOnstruct (non supported), contains VHLD code
    # -- (non supported)
    "TinyFPGA-BX/clock_divider",
]


def collect_examples(examples_root: Path) -> List[str]:
    """Scan the examples directory and identify all the examples.
    Returns a list with items such as "Alhambra-II/Blinky".
    'examples_root' is the path of the repo/examples dir.
    The function returns also examples that are in the PROBLEMATIC_EXAMPLES
    list.
    """
    dir_entries = os.listdir(examples_root)
    # -- Collect the board names. We select only dirs that don't
    # -- start with ".".
    boards = [
        e
        for e in dir_entries
        if (e[0] not in ".") and (examples_root / e).is_dir()
    ]

    result = []
    # -- Iterate boards.
    for board in boards:
        board_dir = examples_root / board
        # -- Iterate board examples. we select only entries
        # -- that are dirs and don't start with "."
        dir_entries = os.listdir(board_dir)
        board_examples = [
            f"{board}/{e}"
            for e in dir_entries
            if (e[0] not in ".") and (board_dir / e).is_dir()
        ]
        result.extend(board_examples)

    return result
