#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run "dunst"
run "nitrogen --restore"
run "xset s 540"
run "xset dpms 600 600 600"
run "picom"
run "compton"
run "nm-applet"
run "playerctld daemon"
run "alttab -fg '#d58681' -bg '#4a4a4a' -frame '#eb564d' -t 128x150 -i 127x64 -d 1"
