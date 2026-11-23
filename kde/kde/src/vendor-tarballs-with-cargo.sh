#!/bin/bash

# Copyright 2026  Patrick J. Volkerding, Sebeka, Minnesota, USA
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

CWD=$(pwd)

# Find tarballs that need their Rust "vendored":
for file in $CWD/*.tar.xz ; do
  if tar tf $file | grep -q Cargo.toml ; then
    if [ "$1" = "--dry-run" ]; then
      echo "Would vendor $(basename $file)."
      continue
    fi
    # Extract:
    TMPDIR=$(mktemp -d)
    pushd $TMPDIR
    tar xf $file
    find . -name Cargo.toml | while read CARGOTOML ; do
      ( cd $(dirname $CARGOTOML)
        cargo vendor-filterer --platform="x86_64-unknown-linux-gnu" --platform="i686-unknown-linux-gnu"
      )
    done
    tar cf $(basename $file .tar.xz).tar $(basename $file .tar.xz)
    plzip -9 $(basename $file .tar.xz).tar
    touch -r $file $(basename $file .tar.xz).tar.lz
    mv $(basename $file .tar.xz).tar.lz $CWD
    # Remove the unvendored version:
    rm -v -f "$file" "${file}.sig"
    popd
    rm -r $TMPDIR
  fi
done
