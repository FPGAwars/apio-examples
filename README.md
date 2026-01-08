
**IMPORTANT** [Dec 24th 2025] The main branch of this repository was changed from `master`
to a new branch called `main` and the old `master` branch is now frozen in read-only state. Please submit all future pull requests on the new branch `main`. The frozen branch should keep serving
this URL https://raw.githubusercontent.com/fpgawars/apio-examples/master/VERSION to Apio versions
before 1.2.0.

> **Note:** Please **do not** open issues in this repository.
> For any questions, discussions, or bug reports, use the [main Apio repository](https://github.com/FPGAwars/apio).

# Apio examples package

A package with sample FPGA project for [Apio](https://github.com/fpgawars/apio)

## Creating a release

Pre-releases are created daily by the `build-pre-release` workflow and are deleted after
a few days. To keep a release, edit it and unselect `pre-release` checkbox.

After you unselected the 'pre-release', you can make Apio using it by editing the version
of the `examples` package in `fpgawars/apio repo` dir `remote-control`.

## Guides for authoring examples

### Directory structure

The examples in the apio-examples repository have the following directory structure

```
examples
    <board-id>
        <example-id>
            <example-files>
```

Where:

**Board-id**
This the exact FPGA board id of the example, as listed by `apio examples -l`. This is also the `board=` value in the `apio.ini` file of the example.

```
alhambra-ii   # good
Alhambra-II   # bad
```

**Example-id**
This is a short name that identify the example among the examples of that bord and it is in lower-case format with ASCII alphanumeric characters only (no unicode).

```
blinky             # good
divide-by-pi       # good

Blinky             # bad
Divide By Pi       # bad
divide_by_pi       # bad
divide-by-3.14     # bad
```

**Examble-files**
These are the files that make up the examples. Subdirectories are not allow in the example directory.

---

### Board level requirements

**A board should have at least one example.** This is self explanatory.

---

### Example level requirements

**An example should be license compatible**
The publishing of the example should be compatible with the LICESNE of the FPGAWars' apio-examples repository.

**An example should include an 'info' file**
The example directory should include a text file named `info` with a single
line, up to 50 characters long, desdribing the example.

**An example should have an apio.ini**
Each example should contain an apio.ini file with all the required options. Example

```
[env:default]
board = alhambra-ii
top-module = main
```

**An example should not be broken**
An example should pass successfuly the following commands `apio build`, `apio upload`, `apio report`, `apio graph`.

**A testbench should not be broken**
If an example contains a testbench (\*\_tb.v files), they should pass successfuly the commands `apio test` and `apio sim <testbench>`.

---

### Board level 'nice to have'

**A 'template' example for new projects**
Having for your board an example called `template` will provide your users with
good starting point to start a new project. The `template` should have a full
constrains file for that FPGA which the users can then trim or comment out.

---

### Example level 'nice to have'

**lower-case file names**
It's recomanded to use `lower-case` format (ASCII a-z, 0-9, no unicode) for base file
names. For example:

```
clock-divider.v
my-test-bench_tb.v.
main.v
```

**A least one testbench**
A good example should have at least one testbench.

**A .gtkw file for each testbench**
Having a .gtkw file for each testbench makes your example more user friedly.
You can the .gtkw files by running `apio sim <testbench>`,
selecting in the GUI the signals to display, and saving the .gtkw file using the menu entry `File | Write Save File`.

**Consistent example names**
If you create a hello-world example that turn on or blinks a led, prefer to reuse
common example name from other boards, such as `ledon` or `blinky` rathe than
inventing new names.

---

## License

The Apio project itself is licensed under the GNU General Public License version 3.0 (GPL-3.0).
Pre-built packages may include third-party tools and components, which are subject to their
respective license terms.
