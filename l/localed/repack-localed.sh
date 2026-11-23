#!/bin/sh
VERSION=$(echo *.tar.gz | rev | cut -f 3- -d . | rev)
DATE=$(tar tvf ${VERSION}.tar.gz | head -n 1 | tr -s " " | cut -f 4,5 -d " ")
rm -rf localed
tar xf ${VERSION}.tar.gz
mv localed localed-${VERSION}
tar cf localed-${VERSION}.tar localed-${VERSION}
plzip -9 localed-${VERSION}.tar
touch -d "$DATE" localed-${VERSION}.tar.lz
rm -rf localed-${VERSION}
rm -f tar xf ${VERSION}.tar.gz
