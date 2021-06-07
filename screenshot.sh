#!/bin/sh
import -window root /dev/shm/screenshot.jpg
xclip -selection clipboard -target image/jpeg -i /dev/shm/screenshot.jpg
rm /dev/shm/screenshot.jpg


