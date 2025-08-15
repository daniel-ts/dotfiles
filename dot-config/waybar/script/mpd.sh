#!/etc/profiles/per-user/dan/bin/bash

STATE=$(mpc status '%state%')
case $STATE in
    'playing')
	mpc pause
	;;
    'paused')
	mpc play
	;;
    *)
	dunstify "[mpd] bad mpc state: $STATE"
	;;
esac
