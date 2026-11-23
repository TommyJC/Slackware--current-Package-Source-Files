#!/bin/sh

# Copyright 2025  Patrick J. Volkerding, Sebeka, Minnesota, USA
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


PKGNAM=moreutils

# Tag to checkout:
TAG=0.70

# Clear download area:
rm -rf ${PKGNAM}

# Clone repository:
git clone git://git.joeyh.name/${PKGNAM}

# checkout $BRANCH:
( cd ${PKGNAM} 
  git checkout $TAG || exit 1
)

HEADISAT="$( cd ${PKGNAM} && git log -1 --format=%h )"
DATE="$( cd ${PKGNAM} && git log -1 --format=%cd --date=format:%Y%m%d )"
LONGDATE="$( cd ${PKGNAM} && git log -1 --format=%cd --date=format:%c )"
# Cleanup.  We're not packing up the whole git repo.
( cd ${PKGNAM} && find . -type d -name ".git*" -exec rm -rf {} \; 2> /dev/null )

mv ${PKGNAM} ${PKGNAM}-${TAG}
tar cf ${PKGNAM}-${TAG}.tar ${PKGNAM}-${TAG}
plzip -9 -f ${PKGNAM}-${TAG}.tar
rm -rf ${PKGNAM}-${TAG}
touch -d "$LONGDATE" ${PKGNAM}-${TAG}.tar.lz
echo
echo "${PKGNAM} branch $BRANCH with HEAD at $HEADISAT packaged as ${PKGNAM}-${TAG}.tar.lz"
echo
