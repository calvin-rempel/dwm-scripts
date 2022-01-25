#!/bin/sh

. $HOME/src/dwm-scripts/statusBar/statusBarUpdate.sh

maxBatteryCap=$(sysctl -n hw.sensors.acpibat0.watthour0|cut -d' ' -f1|sed 's/\.//')

getRemCap(){
	remCap=$(sysctl -n hw.sensors.acpibat0.watthour3|cut -d' ' -f1|sed 's/\.//')
	echo $(expr $remCap \* 100 / $maxBatteryCap)
}

getChargeStatus(){
	status=$(sysctl -n hw.sensors.acpibat0.raw0|cut -d' ' -f1)
	case $status in
		"0")
			echo "=" #Plugged In
			;;
		"1")
			echo "-" #Discharging
			;;
		"2")
			echo "+" #Charging
			;;
	esac		
}

touch /tmp/battery_chargeStatus

while [ 1 ]
do
	batteryPercent=$(getRemCap)
	chargeStatus=$(getChargeStatus)
	newStatus=$(echo "$chargeStatus $batteryPercent")
	oldStatus=$(cat /tmp/battery_chargeStatus)

	if [ "$newStatus" != "$oldStatus" ]
	then
		echo "$chargeStatus $batteryPercent" > /tmp/battery_chargeStatus
		updateBar
	fi

	sleep 15
done
