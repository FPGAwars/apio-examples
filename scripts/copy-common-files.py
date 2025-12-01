#!/usr/bin/env python3
"""
copy-common-files.py

Run from repository root.

By default: actually copies common files
Use --dry-run to see what would happen without changing anything

Usage:
    ./process-common-files.py                 # actually copy (default)
    ./process-common-files.py --dry-run       # show what would be copied
    ./process-common-files.py --clean         # actually delete shared files
    ./process-common-files.py --dry-run --clean  # show what would be deleted
"""

import shutil
from pathlib import Path
import sys


COMMON_DIR = Path("common-examples-files")
EXAMPLES_DIR = Path("examples")


def get_targets():
    return [
        p for board in EXAMPLES_DIR.iterdir() if board.is_dir()
        for p in board.iterdir() if p.is_dir()
    ]


def process_one_example(example_dir: Path, dry_run: bool, clean: bool) -> int:
    """Process a single example directory: copy or delete common files."""
    count = 0
    for item in COMMON_DIR.iterdir():
        dest = example_dir / item.name

        if clean:
            if dest.exists():
                if dry_run:
                    print(f"Would delete: {dest}")
                else:
                    (shutil.rmtree if dest.is_dir() else dest.unlink)(dest)
                    print(f"Deleted: {dest}")
                count += 1
        else:
            if dry_run:
                print(f"{'Would overwrite' if dest.exists() else 'Would copy'}: {dest}")
            else:
                if dest.exists():
                    (shutil.rmtree if dest.is_dir() else dest.unlink)(dest)
                (shutil.copytree if item.is_dir() else shutil.copy2)(item, dest)
                print(f"Copied: {dest}")
            count += 1
    return count


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Copy or clean common example files")
    parser.add_argument("--dry-run", action="store_true",
                        help="Show what would happen without making changes")
    parser.add_argument("--clean", action="store_true",
                        help="Delete common files from examples instead of copying")
    args = parser.parse_args()

    if not COMMON_DIR.exists():
        print(f"Error: Directory not found: {COMMON_DIR}")
        sys.exit(1)

    targets = get_targets()
    if not targets:
        print("No example directories found under examples/")
        return

    action = "DELETE" if args.clean else "COPY"
    mode = "DRY RUN" if args.dry_run else "APPLYING"
    print(f"{mode} — {action} common files → {len(targets)} example directories\n")

    total_count = 0
    for example_dir in targets:
        total_count += process_one_example(example_dir, args.dry_run, args.clean)

    verb = "deleted" if args.clean else "copied"
    print(f"\nDone! {total_count} items {verb} across {len(targets)} directories.")


if __name__ == "__main__":
    main()
