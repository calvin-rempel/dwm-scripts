#!/bin/sh
maxBatteryCap=$(sysctl -n hw.sensors.acpibat0.amphour0|cut -d' ' -f1|sed 's/\.//')

getRemCap(){
	remCap=$(sysctl -n hw.sensors.acpibat0.amphour3|cut -d' ' -f1|sed 's/\.//')
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
