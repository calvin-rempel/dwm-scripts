#!/bin/sh
batteryPath="/sys/class/power_supply/BAT0"
acPath="/sys/class/power_supply/AC"
decoration="|"

while [ 1 ]
do
	
	if [ -d "$batteryPath" ]
	then
		#Set Max Battery Capacity
		if [ "$batteryMax" = "" ]
		then
			batteryMax=$(cat $batteryPath/energy_full_design)
		fi

		#Calculate Charge Level
		batteryCurrent=$(cat $batteryPath/energy_now)
		batteryPercent=$(( $batteryCurrent * 100 / $batteryMax ))

		#Check for Charging Status
		acStatus=$(cat $acPath/online)
		if [ $acStatus -eq 1  ]
		then
			acMessage="🔌"
		else
			acMessage="🔋"
		fi
	
		batteryMessage=$(echo -n "$acMessage$batteryPercent% $decoration ")
	else
		batteryMessage=""
	fi
	
	currentTime=$(date +%b%e\ -\ %H:%M)
	xsetroot -name "$batteryMessage$currentTime;🤨LASERS!"
	#xsetroot -name "top text;bottom text"
	sleep 1m
done
