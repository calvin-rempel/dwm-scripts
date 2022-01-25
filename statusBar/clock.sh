#!/bin/sh
touch /tmp/clock_currentTime

.$HOME/src/dwm-scripts/statusBar/statusBarUpdate.sh

while [ 1 ]
do
	currentTime=$(date +%b%e\ -\ %H:%M)
	echo $currentTime > /tmp/clock_currentTime
	updateBar
	sleep 60
done
