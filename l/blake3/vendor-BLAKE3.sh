#!/bin/bash

VERSION=${VERSION:-1.8.7}

if [ ! -r BLAKE3-$VERSION.tar.lz ]; then
  echo "ERROR: BLAKE3-$VERSION.tar.lz not found"
  exit 1
fi

# Let's get the timestamp correct as long as we're here:
touch -d "$(tar tvf BLAKE3-$VERSION.tar.lz | head -n 1 | cut -d 0 -f 2- | cut -d ' ' -f 2-3)" BLAKE3-$VERSION.tar.lz

# Clear any existing stuff out:
rm -rf BLAKE3-$VERSION

# Extract the original tarball:
tar xf BLAKE3-$VERSION.tar.lz

# Vendor it:
cd BLAKE3-$VERSION
  if ! [ -f /usr/bin/cargo-vendor-filterer ]; then
    echo "WARNING: Creating unfiltered vendor libs tarball!"
    cargo vendor
  else
    cargo vendor-filterer --platform="x86_64-unknown-linux-gnu" --platform="i686-unknown-linux-gnu"
  fi
cd ..
mv BLAKE3-$VERSION BLAKE3-vendored-$VERSION

# Tar up the vendored version:
tar cf BLAKE3-vendored-$VERSION.tar BLAKE3-vendored-$VERSION
plzip -9 BLAKE3-vendored-$VERSION.tar

# Clean up:
rm -rf BLAKE3-vendored-$VERSION
