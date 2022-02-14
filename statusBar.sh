#!/bin/sh

touch /tmp/battery_chargeStatus
touch /tmp/clock_currentTime

maxBatteryCap=$(sysctl -n hw.sensors.acpibat0.watthour0|cut -d' ' -f1|sed 's/\.//')

##
# Function: getRemCap()
# Purpose: To find out how much of the mattery remains in % and return that value via
#          stdout.
# Preconditions: the variable maxBatteryCap - indicating the maximum battery capacity,
#                must be instantiated.
# Postconditions: None
# Side Effects: If invoked without capturing stdout, will write the remaining battery
#               percentage to stdout.
#
#=== Begin Function getRemCap() =========================================================
getRemCap(){
	remCap=$(sysctl -n hw.sensors.acpibat0.watthour3|cut -d' ' -f1|sed 's/\.//')
	echo $(expr $remCap \* 100 / $maxBatteryCap)
}
#--- End Function getRemCap() -----------------------------------------------------------

##
# Function: updateBar()
# Purpose: To gather the resultant clock, battery and language data and write them out to
#          the status bar. Since this data is written to files in /tmp/, this function
#          may be invoked by any script without needing access to the memory space of
#          the main instance.
# Preconditions: /tmp/lang_selected must be instantiated. The users .xsession file is
#                responsible for handling this.
# Postconditions: None.
# Side Effects: Text of statusbar will be updated.
#
#=== Begin Function updateBar() =========================================================
updateBar(){
        newTime=$(cat /tmp/clock_currentTime)	
	battery=$(cat /tmp/battery_chargeStatus)
	lang=$(cat /tmp/lang_selected)
	xsetroot -name "|$lang| $battery% | $newTime"
}
#--- End Function updateBar() -----------------------------------------------------------


##
# Function: getChargeStatus()
# Purpose: To find out what the computer is doing and produce the appropriat charge
#          Status indicator.
# Preconditions: Computer needs to be using this particular sensor in OpenBSD. My older
#                Laptop used a different one.
# Postconditions: None.
# Side Effects: If invoked without capturing the stdout, will write a symbol to stdout.
#
#=== Begin Function getChargeStatus() ===================================================
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
#--- End Function getChargeStatus() -----------------------------------------------------

##
# Function: batteryLoop()
# Purpose: To poll the status of the battery (charge percentage and whether charging
#          or discharging) and update that status. It will update the status bar
#          as well as writing to the file /tmp/battery_chargeStatus such that any other
#          script can invoke the updateBar() function in this script without needing
#          access to the memory space of this instance of the script.
# Preconditions: None.
# Postconditions: /tmp/battery_chargeStatus will be updated and (if applicable)
#                 instantiated.
# Side Effects: Status Bar will be updated.
#
#=== Begin Function batteryLoop() =======================================================
batteryLoop(){
	while [ 1 ]
	do
		batteryPercent=$(getRemCap)
		chargeStatus=$(getChargeStatus)
		newBatStatus=$(echo "$chargeStatus $batteryPercent")
		oldBatStatus=$(cat /tmp/battery_chargeStatus)

		if [ "$newBatStatus" != "$oldBatStatus" ]
		then
			echo "$newBatStatus" > /tmp/battery_chargeStatus
			updateBar
		fi

		sleep 15
	done
}
#--- End Function batteryLoop() ---------------------------------------------------------


## 
# Function: clockLoop()
# Purpose: To check the time, update the currentTime file (which can ensure that other
#          status indicators on the statsBar are updated inbetween clock updates without
#          erasing the current time) and update the statusbar.
# Preconditions: None
# Postconditions: /tmp/clock_currentTime will be updated and instantiated if not already
#                 done.
# Side Effects: Will change the text on the statusBar.
#
#=== Begin Function clockLoop() =========================================================
clockLoop(){
	while [ 1 ]
	do
		currentTime=$(date +%b%e\ -\ %H:%M)
		echo $currentTime > /tmp/clock_currentTime
		updateBar
		sleep 60
	done
}
#--- End Function clockLoop() -----------------------------------------------------------

##
# Function: runLoops()
# Purpose: To start up the various loops as their own thread. This command is invoked
#          from the command line by using "$@" towards the end of the script such that
#          one need only execute: sh statusBar.sh runLoops
# Preconditions: /tmp/clock_currentTime, /tmp/battery_chargeStatus, and /tmp/lang_selected
#                should all have been instantiated.
# Postconditions: Will update currentTime and chargeStatus files.
# Side Effects: Will output text to the statusbar.
#
#=== Begin Function runLoops() ==========================================================
runLoops(){
	clockLoop &
	batteryLoop &
	wait
}
#--- End Function runLoops() ------------------------------------------------------------

"$@"



#00 - Sunny, Clear Skies
#01 - Sunny, Mild Clouds
#https://weather.gc.ca/weathericons/small/00.png
