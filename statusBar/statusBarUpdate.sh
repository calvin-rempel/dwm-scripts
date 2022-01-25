#!/bin/sh
updateBar(){
	newTime=$(cat /tmp/clock_currentTime)	
	battery=$(cat /tmp/battery_chargeStatus)
	lang=$(cat /tmp/lang_selected)
	xsetroot -name "|$lang| $battery% | $newTime"
}
