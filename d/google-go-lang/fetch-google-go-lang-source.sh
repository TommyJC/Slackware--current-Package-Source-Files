#!/bin/bash

# Fetch the Google Go source and convert it to .lz:

VERSION=1.27.3
rm -f go${VERSION}.src.tar.gz
lftpget https://go.dev/dl/go${VERSION}.src.tar.gz || exit 1
gzip -d go${VERSION}.src.tar.gz
plzip -9 go${VERSION}.src.tar
