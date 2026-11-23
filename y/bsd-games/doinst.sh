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

config var/lib/bsdgames/atc_score.new
config var/lib/bsdgames/robots_roll.new
config var/lib/bsdgames/hack/perm.new
config var/lib/bsdgames/hack/record.new
config var/lib/bsdgames/phantasia/lastdead.new
config var/lib/bsdgames/phantasia/scoreboard.new
config var/lib/bsdgames/phantasia/monsters.new
config var/lib/bsdgames/phantasia/mess.new
config var/lib/bsdgames/phantasia/characs.new
config var/lib/bsdgames/phantasia/motd.new
config var/lib/bsdgames/phantasia/gold.new
config var/lib/bsdgames/phantasia/void.new
config var/lib/bsdgames/snakerawscores.new
config var/lib/bsdgames/saillog.new
config var/lib/bsdgames/battlestar.log.new
config var/lib/bsdgames/snake.log.new
config var/lib/bsdgames/criblog.new
config var/lib/bsdgames/cfscores.new
( cd var/lib/bsdgames ; find . -name "*.new" -exec rm -f "{}" \; )

# Keep perms on these so that turning them off sticks through upgrades:
preserve_perms etc/profile.d/bsd-games-login-fortune.csh.new
preserve_perms etc/profile.d/bsd-games-login-fortune.sh.new

