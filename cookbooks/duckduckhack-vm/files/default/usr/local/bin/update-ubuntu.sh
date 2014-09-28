#!/bin/bash
function pause(){
	read -p "$*"
}
sudo aptitude update
sudo aptitude upgrade

echo "If Ubuntu was updated, please reboot when you get a chance."
# If we are under X11
if [ -n "${DISPLAY}" ]; then
	pause "Press [Enter] to exit this script."
fi
