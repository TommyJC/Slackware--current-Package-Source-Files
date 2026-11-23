# Run pipewire-start unless we're in runlevel 1:
/sbin/runlevel | grep -q 1$ || /bin/sh /usr/bin/pipewire-start
