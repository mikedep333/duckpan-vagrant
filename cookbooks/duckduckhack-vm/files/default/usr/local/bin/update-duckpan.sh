#!/bin/bash

LOG=/tmp/update-duckpan.log

function pause(){
	read -p "$*"
}

function exit_not_installed
{
	echo ""                                                               2&>1 | tee -a $LOG
	echo "DuckPAN is not installed"         2>&1 | tee -a $LOG
	exit_script
}
function exit_failed_to_download()
{
	echo ""                                                               2&>1 | tee -a $LOG
	echo "Failed to download install.pl"    2>&1 | tee -a $LOG
	exit_script
}
function exit_failed_to_run()
{
	echo ""                                                               2&>1 | tee -a $LOG
	echo "Failed to run duckpan-install.pl" 2>&1 | tee -a $LOG
	exit_script
}
function exit_script()
{
	# If we are under X11
	if [ -n "${DISPLAY}" ]; then
		echo ""                                                           2&>1 | tee -a $LOG
		pause "Press [Enter] to exit this script."
	fi
	exit 0
}

# This includes sourcing the perlbrew script
source /opt/perlbrew/etc/bashrc

echo "Updating DuckPAN"                                                  2>&1 | tee $LOG
echo ""                                                                  2>&1 | tee -a $LOG
echo "This could take several minutes or longer if your machine is slow" 2>&1 | tee -a $LOG
echo "or if there is a large update to install."                         2>&1 | tee -a $LOG
echo ""                                                                  2>&1 | tee -a $LOG
echo "There is a link to this script's log file on your desktop."  2>&1 | tee -a $LOG
echo ""                                                                  2>&1 | tee -a $LOG

# Enable other users to run the update-duckpan.sh script
chmod 666 $LOG

which duckpan &> /dev/null || exit_not_installed
cd ~

echo "Attempting to download http://duckpan.com/install.pl as duckpan-install.pl" 2>&1 | tee -a $LOG
# By setting --tries=1, the longest a user will have to wait is 60 seconds,
# which would occur for a "connection timed out" error.
# (Ubuntu 12.04 default of /proc/sys/net/ipv4/tcp-syn-retries = 5)
#
# Other errors such as "No route to host" take no more than a few seconds.
wget --tries=1 -L http://duckpan.com/install.pl -O duckpan-install.pl             &>> $LOG || exit_failed_to_download
echo ""                                                                           2>&1 | tee -a $LOG
echo "duckpan-install.pl downloaded successfully. Running it now."                2>&1 | tee -a $LOG
echo "Its output will be logged to the log file."                                  2>&1 | tee -a $LOG
perl duckpan-install.pl                                                           &>> $LOG || exit_failed_to_run
echo ""                                                                           2>&1 | tee -a $LOG
echo "DuckPAN was updated successfully or there was no update to install."        2>&1 | tee -a $LOG

exit_script
