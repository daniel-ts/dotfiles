#!/bin/bash

STATE=$(swaymsg -t get_bar_config bar-0 | jq .mode)
case $STATE in
    '"dock"')
	swaymsg bar mode hide bar-0
	;;
    '"hide"')
	swaymsg bar mode dock bar-0
	;;
    *)
	dunstify "[zen] bad waybar state: $STATE"
	;;
esac
