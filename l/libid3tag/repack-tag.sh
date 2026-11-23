VERSION=$(basename $(/bin/ls 0*.tar.gz) .tar.gz)
rm -rf libid3tag libid3tag-${VERSION} libid3tag-${VERSION}.tar*
tar xf 0*.tar.gz
mv libid3tag libid3tag-${VERSION}
tar cf libid3tag-${VERSION}.tar libid3tag-${VERSION}
plzip -9 libid3tag-${VERSION}.tar
rm -r libid3tag-${VERSION}
touch -d "$(tar tvf 0*.gz | head -n 1 | cut -w -f 4)" libid3tag-${VERSION}.tar.lz
rm -f 0*.tar.gz
