#!/bin/sh

alttab -w 1 -fg '#aabac8' -bg '#000000' -frame '#cd00cd' -t 128x150 -i 127x64 -d 1 &
dunst &
picom &
compton &
nm-applet &
xset s 540
xset dpms 600 600 600
