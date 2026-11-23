#!/bin/sh
config() {
  NEW="$1"
  OLD="`dirname $NEW`/`basename $NEW .new`"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}
preserve_perms() {
  NEW="$1"
  OLD="$(dirname ${NEW})/$(basename ${NEW} .new)"
  if [ -e ${OLD} ]; then
    cp -a ${OLD} ${NEW}.incoming
    cat ${NEW} > ${NEW}.incoming
    mv ${NEW}.incoming ${NEW}
  fi
  config ${NEW}
}

preserve_perms etc/geninitrd.d/pre-install/dkms-bcachefs.sh.new

# Clean up bcachefs dkms modules and install the incoming one if bcachefs dkms
# modules are detected.
#
# If a package upgrade includes bcachefs-tools and kernel-*, then this should clean
# up bcachefs's dkms installation immediately and upgrade the module on the running 
# kernel after bcachefs-tools is upgraded. Followed by the dkms system rebuilding 
# the bcachefs module again on the new kernel at next reboot. If it's just a 
# bcachefs-tools upgrade, this will install the new module immediately.
#
# If bcachefs's dkms installation isn't cleaned up when bcachefs-tools is upgraded,
# then entries in /var/lib/dkms/bcachefs/* will have broken symlinks, and dkms will 
# report errors/broken modules that require "manual intervention".

# Only do this if we have dkms:
if [ -x usr/sbin/dkms ]; then

  BCACHEFS_DKMS_DIR="/var/lib/dkms/bcachefs"

  # Print a dkms status report for user, keeping some noise down in case of broken links:
  dkms status 2> /dev/null | grep bcachefs

  # Use a more robust grep to make sure bcachefs is installed and not broken
  # Note: These could be multiline if theres more than one bcachefs module installed
  BCACHEFS_INSTALLED="$(dkms status 2> /dev/null | grep "bcachefs.*installed")"
  BCACHEFS_BROKEN="$(dkms status 2> /dev/null | grep "bcachefs.*broken")"

  # Clean up any broken dkms installs if found:
  if [ -n "$BCACHEFS_BROKEN" ]; then
    echo "Cleaning up broken bcachefs dkms modules"

    # Delete directories for broken dkms installs first:
    while read -r line; do
      ver="$(echo $line | cut -d':' -f1 | cut -d'/' -f2)"
      rm -rfv ${BCACHEFS_DKMS_DIR}/${ver}
    done <<< $BCACHEFS_BROKEN

    # Then remove any remaining broken symlinks in the dkms directory:
    find "$BCACHEFS_DKMS_DIR" -xtype l -delete
  fi

  # Install the new module if there were past modules:
  if [ -n "$BCACHEFS_BROKEN" ] || [ -n "$BCACHEFS_INSTALLED" ]; then
    # Note: %%VERSION%% is meant to be 'sed' with the version,
    #       when copying the doinst.sh in the slackbuild.
    #       E.g:
    #       sed "s/%%VERSION%%/$VERSION/g" $CWD/doinst.sh > $PKG/install/doinst.sh
    #       Where $VERSION, $CWD, and $PKG are defined in the slackbuild already.
    # Note: No kernel version specified means install for running kernel:
    dkms install bcachefs/%%VERSION%%
  fi

fi
