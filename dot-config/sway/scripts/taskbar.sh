#!/bin/bash

STATE=$(swaymsg -t get_bar_config bar-1 | jq .hidden_state)
case $STATE in
    '"show"')
	swaymsg bar hidden_state hide bar-1
	;;
    '"hide"')
	swaymsg bar hidden_state show bar-1
	;;
    *)
	notify-send "[waybar] bad waybar hidden_state: $STATE"
	;;
esac
