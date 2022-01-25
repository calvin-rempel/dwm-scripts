#!/bin/sh
#Revert back to US Keyboard so that if I am using a foreign keyboard layout
#Prior to locking I am not locked out.
setxkbmap us
echo "us" > /tmp/lang_selected

#Lock the screen
slock
