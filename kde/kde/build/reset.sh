#!/bin/sh
# A script to reset all the build numbers in a module
# to 1 by removing any existing build file.
#
# Call it with the name of the module to reset:
#
# ./reset.sh plasma

if [ -z $1 ]; then
  echo "ERROR: must list a module to reset"
  exit 1
fi
if [ ! -r ../modules/$1 ]; then
  echo "ERROR: module $1 does not exist in ../modules"
  exit 1
fi
cat ../modules/$1 | grep -v "^$" | grep -v "^#" | while read buildfile ; do
  if [ -r "$buildfile" ]; then
    rm -v "$buildfile"
  fi
done
