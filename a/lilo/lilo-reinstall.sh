#!/bin/bash
# If we are using LILO, see if it needs to be reinstalled:
if [ -r /etc/lilo.conf ] && [ $(($(cat /proc/sys/kernel/bootloader_type)/16)) = 0 ]; then
  # Are we using /boot/vmlinuz-generic?
  if cat /etc/lilo.conf | sed 's/ //g' | grep -q -e "^image=/boot/vmlinuz-generic$" -e "^image=/boot/vmlinuz$" ; then
    # See if the boot sector contains the string 'LILO':
    liloboot="$(cat /etc/lilo.conf | sed 's/ //g' | grep "^boot=" | cut -f 2 -d =)"
    if dd if=${liloboot} bs=512 count=1 2>&1 | grep -q LILO ; then
      # LILO is installed. Reinstall it:
      echo "Your machine is using LILO. The running kernel is ($(uname -r))"
      echo "and the /boot/vmlinuz-generic symlink points to ($(readlink /boot/vmlinuz-generic | cut -f 2 -d -))."
      echo "Reinstalling LILO:"
      lilo
    fi
  fi
fi
