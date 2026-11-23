#!/bin/bash
#
# ---------------------------------------------------------------------------
# Add a KDE5 package to the ktown tree.
# Note that every Qt5 compatibility package will be suffixed with '5'
# in order to co-install them with their Qt6 based successors.
# ---------------------------------------------------------------------------
#
MYFILES="${@}"
SLACKWARE_ROOT=${SLACKWARE_ROOT:-"~ftp/pub/Linux/Slackware/slackware64-current"}
KDE_ROOT=${KDE_ROOT:-"${SLACKWARE_ROOT}/source/kde/kde"}

if [ -z "$MYFILES" ]; then
  # If the user didn't provide a packagename, show the commands that would run.
  MYFILES="PKGNAME5"
  cat <<EOT
    # Add the source tarball from Slackware's original location:
    cp -ia ${KDE_ROOT}/src/*/${MYFILES::-2}-[0-9]?*z src/kde5/
    # Add the source --> packagename transformation:
    echo kde5/${MYFILES::-1} > pkgsrc/${MYFILES}
    # Add a slack-desc file:
    cp -ia slack-desc/${MYFILES::-1} slack-desc/${MYFILES}
    sed -i -e "s/${MYFILES::-1}/${MYFILES}/g" slack-desc/${MYFILES}
    # Configure the correct cmake file:
    ln -s cmake5 cmake/${MYFILES}
EOT
else
  for MYFILE in ${MYFILES} ; do
    # Add the source tarball from Slackware's original location:
    cp -ia ~ftp/pub/Linux/Slackware/slackware64-current/source/kde/kde/src/*/${MYFILE::-1}-[0-9]?*z src/kde5/
    # Add the source --> packagename transformation:
    echo kde5/${MYFILE::-1} > pkgsrc/${MYFILE}
    # Add a slack-desc file:
    cp -ia slack-desc/${MYFILE::-1} slack-desc/${MYFILE}
    sed -i -e "s/${MYFILE::-1}/${MYFILE}/g" slack-desc/${MYFILE}
    # Configure the correct cmake file:
    ln -s cmake5 cmake/${MYFILE}
  done
fi

echo ">>"
echo ">> Be sure to add '${MYFILES}' to 'modules/kde5' as well!"
echo ">>"
