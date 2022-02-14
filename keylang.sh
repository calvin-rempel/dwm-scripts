#!/bin/sh
#This script is designed to cycle the user between key languages
. $HOME/src/dwm-scripts/statusBar.sh

langFile="/tmp/lang_selected"

if [ -f $langFile ]
then
	currLang=$(cat $langFile)
else
	currLang="us"
fi
echo $currLang
if [ "$currLang" == "us" ]
then
	currLang="el"
elif [ "$currLang" == "el" ]
then
	currLang="de"
else
	currLang="us"
fi

echo $currLang
setxkbmap $currLang
echo $currLang > $langFile

updateBar
