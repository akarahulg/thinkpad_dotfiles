#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}
run "dust"
run "nitrogen --restore"
run "xset s 540"
run "xset dpms 600 600 600"
run "picom"
run "compton"
run "nm-applet"
run "~/.config/awesome/customlock.sh"
