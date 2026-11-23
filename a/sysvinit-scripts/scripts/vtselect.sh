#!/bin/bash
# This script is used from /sbin/init (configured in /etc/inittab) to start
# a virtual terminal using either the kernel's built-in VT subsystem (fbcon)
# or KMSCON.

# First, load the defaults:
. /etc/default/vtselect

# The TTY to use should have been passed at $1:
TTY=$1

# Additional options for a standard VT through agetty:
VTOPTS=${VTOPTS:-"38400 $TTY linux"}

# Additional options for KMSCON:
KMSOPTS=${KMSOPTS:-"--vt $TTY"}

# If this tty is not listed in $KMSCONSOLES then start an fbcon console:
if ! echo "$KMSCONSOLES" | grep -wq $TTY ; then
  # If $TTY=tty1 then don't clear it:
  if [ "$TTY" = "tty1" ]; then
    exec /sbin/agetty --noclear $VTOPTS
  else
    exec /sbin/agetty $VTOPTS
  fi
fi

# Otherwise, start a KMSCON if we can:
if cat /proc/fb | grep -q drmfb ; then
  if [ -x /usr/bin/kmscon ]; then
    exec /usr/bin/kmscon $KMSOPTS
  fi
fi

# Fallback:
exec /sbin/agetty $VTOPTS
