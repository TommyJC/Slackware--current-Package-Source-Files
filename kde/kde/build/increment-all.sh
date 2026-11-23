#!/bin/sh
# A script to increment the build numbers for all packages
# built by kde.SlackBuild.

./increment.sh $(cat ../modules/* | grep -v "^//" | grep -v "^#" | grep -v "^$" | sort | uniq)
