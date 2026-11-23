#!/bin/bash
# Thanks to lucabon for this script that makes a symlink to the
# rustlib instead of trying to copy all of /usr/lib (which also happens
# to not work when /usr/lib64 is the system lib directory).

TMP=$1
LIBDIRSUFFIX=$2
PARENT_PID=$3

triplet=$(basename $(dirname $(echo /usr/lib${LIBDIRSUFFIX}/rustlib/${ARCH}*/lib)))
d=$TMP/build/$triplet/stage0-sysroot/lib${LIBDIRSUFFIX}/rustlib/$triplet/lib

# Monitor the build directory symlink until the SlackBuild parent caller dies:
while kill -0 $PARENT_PID 2>/dev/null; do
  if [ -d "$d" ] && [ ! -h "$d" ]; then
    echo "$(date) - Relinking..."
    rm -rf "$d" && ln -sv /usr/lib${LIBDIRSUFFIX}/rustlib/$triplet/lib "$d"
  fi
done
