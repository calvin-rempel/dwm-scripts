#!/bin/sh
#batteryPath="/sys/class/power_supply/BAT0"
#acPath="/sys/class/power_supply/AC"
#decoration="|"

while [ 1 ]
do
	
	currentTime=$(date +%b%e\ -\ %H:%M)
	xsetroot -name "$currentTime"
	#xsetroot -name "top text;bottom text"
	sleep 60
done
