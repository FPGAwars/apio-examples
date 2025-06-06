#!/bin/bash 

# Constructs the example package directory tree. Called
# from the build workflow.



# Usage:
#  ./build.sh

# -- Set the version the generated package
#VERSION=0.1.4

# For debugging, echo executed commands.
# set -x

# Exit on any error
set -e

# Set english language for propper pattern matching
export LC_ALL=C

# Sanity check
#if find . | grep -e _build -e .sconsign.dblite
#then
#  echo
#  echo "Error: the examples directory seems to contain build artifacts."
#  echo "Try running ./clean_examples.sh"
#  exit 1
#fi

# -- Save the current dir path.
WORK_DIR=$PWD

# -- This version is stored in a temporal file so that github actions
# -- can read it and figure out the package name for upload it to
# -- the new release
#echo "$VERSION" > "VERSION_BUILD"

# -- Show the packaged version
#echo "Package version: ${VERSION}"

# -- Construct the package name. 
#PACKAGE_NAME="apio-examples-${VERSION}"

# -- Show the package name
#echo "Package name: ${PACKAGE_NAME}"

# -- Make an empty package dir.
rm -rf "_package"
mkdir -p "_package"

# -- Copy the examples direcory to package dir but name with the
# --  package name.
cp -r ./examples _package/${PACKAGE_NAME}

# -- Copy the license file.
cp LICENSE _package/${PACKAGE_NAME}

# -- Copy the build version as VERSION file.
# cp VERSION_BUILD _package/${PACKAGE_NAME}/VERSION

# -- Go to the examples dir
cd _package/${PACKAGE_NAME}

# -- Zip the dir with the examples copies.
#zip -r "../${PACKAGE_NAME}.zip" *

# -- Return to the original directory (repo top).
cd ${WORK_DIR}

# -- All done.
echo "Generated package files at _package"
#echo
#echo "Generated package file"
#ls -al  "_package/${PACKAGE_NAME}.zip"
#echo "All done OK."


