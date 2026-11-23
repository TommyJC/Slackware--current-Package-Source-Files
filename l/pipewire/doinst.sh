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
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ -e $OLD ]; then
    cp -a $OLD ${NEW}.incoming
    cat $NEW > ${NEW}.incoming
    mv ${NEW}.incoming $NEW
  fi
  config $NEW
}

# Install profile scripts for console use:
preserve_perms etc/profile.d/pipewire.csh.new
preserve_perms etc/profile.d/pipewire.sh.new

# Install default options file:
config etc/default/pipewire.new

# Toss redundant sample files:
for file in pipewire.desktop pipewire-pulse.desktop ; do
  cmp -s etc/xdg/autostart/${file} etc/xdg/autostart/${file}.sample && rm etc/xdg/autostart/${file}.sample
done

# Disable pulseaudio.desktop:
if [ -r etc/xdg/autostart/pulseaudio.desktop ]; then
  if ! grep -q "^Hidden=true$" etc/xdg/autostart/pulseaudio.desktop ; then
    echo "Hidden=true" >> etc/xdg/autostart/pulseaudio.desktop
  fi
fi

# Pipewire is now the default multimedia server, so if we see pulseaudio
# running let's kill it so that it doesn't interfere:
killall --ns $$ /usr/bin/pulseaudio 1> /dev/null 2> /dev/null

# Recompile glib schemas:
if [ -e usr/share/glib-2.0/schemas ]; then
  if [ -x /usr/bin/glib-compile-schemas ]; then
    /usr/bin/glib-compile-schemas usr/share/glib-2.0/schemas >/dev/null 2>&1
  fi
fi
