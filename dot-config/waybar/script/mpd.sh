#!/bin/bash

STATE=$(mpc status '%state%')
case $STATE in
    'playing')
	mpc pause
	;;
    'paused')
	mpc play
	;;
    *)
	notify-send "[mpd] bad waybar state: $STATE"
	;;
esac
