VERSION=${VERSION:-1.39.7}
rm -rf bcachefs-tools-*
lftpget https://evilpiepirate.org/bcachefs-tools/bcachefs-tools-${VERSION}.tar.sign
lftpget https://evilpiepirate.org/bcachefs-tools/bcachefs-tools-${VERSION}.tar.zst
lftpget https://evilpiepirate.org/bcachefs-tools/bcachefs-tools-vendored-${VERSION}.tar.sign
lftpget https://evilpiepirate.org/bcachefs-tools/bcachefs-tools-vendored-${VERSION}.tar.zst
