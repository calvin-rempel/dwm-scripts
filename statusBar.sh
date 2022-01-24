#!/bin/sh
#batteryPath="/sys/class/power_supply/BAT0"
#acPath="/sys/class/power_supply/AC"
#decoration="|"

. $HOME/src/dwm-scripts/battery.sh

while [ 1 ]
do
	batteryPercent=$(getRemCap)
	chargeStatus=$(getChargeStatus)

	currentTime=$(date +%b%e\ -\ %H:%M)
	
	xsetroot -name "$chargeStatus $batteryPercent% | $currentTime"
	#xsetroot -name "top text;bottom text"
	sleep 60
done
