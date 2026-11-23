#!/bin/bash

VERSION=${VERSION:-18.0.0}

rm -f UCD*.zip Unihan*.zip license.txt
lftpget https://www.unicode.org/Public/$VERSION/ucd/UCD.zip
lftpget https://www.unicode.org/Public/$VERSION/ucd/Unihan.zip
lftpget https://www.unicode.org/license.txt

mv UCD.zip UCD-${VERSION}.zip
mv Unihan.zip Unihan-${VERSION}.zip
