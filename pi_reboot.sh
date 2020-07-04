#!/bin/bash
# This script runs at a reboot and either wait for to reoot once every 24 hours 
# or at midnight local time.
# Since we run at reboot we need to wait for a period of time to see if ntp 
# is syncing succesfully. We will wait for 1 hour after reboot.
if [ "$1" == "" ]; then
	echo "Using system defined time zone"
else
	export TZ=$1
fi
date
echo "Waiting 60 seconds to let everything come up"
sleep 60
isntpd=$(ps -A | grep -c -i "ntpd")
if [ $isntpd -gt 0 ]; then
	echo "NTPD running sleeping 59 minutes to see if we are syncing via NTP"
	sleep 3540
	unsync=$(ntpq -c rl | grep -c -i "stratum=16") 
	if [ $unsync -gt 0 ]; then 
		echo "No time sync. Waiting 23 hours to reboot."
		sleep 82800
                if [ -e "/home/pi/.PIMAINT.LCK"]
                then
			echo "Maintenance job is still apparaently running waiting 15 minutes..."
                        sleep 900
                fi
                if [ -e "/home/pi/.PIMAINT.LCK"]
                then
			echo "There may be an issue the maintenance job is still running, deleteing lock file and rebooting."
                        sudo rm /home/pi/.RPIWAREMAINT.LCK
		fi
		echo "Rebooting..."
		sudo /sbin/shutdown -r now
	else
		echo "Good time sync. Waiting until midnight to reboot"
		difference=$(($(date -d "0:00" +%s) - $(date +%s)))
		echo $difference
		if [ $difference -lt 0 ]
		then
    			sleep $((86400 + difference))
		else
    			sleep $difference
		fi
		if [ -e "/home/pi/.PIMAINT.LCK"]
		then
			echo "Maintenance job is still apparaently running waiting 15 minutes..."
			sleep 900
		fi
		if [ -e "/home/pi/.PIMAINT.LCK"]
		then
			echo "There may be an issue the maintenance job is still running, deleteing lock file and rebooting."
			sudo rm /home/pi/.PIMAINT.LCK
		fi
		echo "Rebooting..."
		sudo /sbin/shutdown -r now
	fi
else
	echo "NTPD is not running sleeping 23 hrs 59 minutes until reboot"
	sleep 86340
        if [ -e "/home/pi/.PIMAINT.LCK"]
        then
		echo "Maintenance job is still apparaently running waiting 15 minutes..."
                sleep 900
        fi
        if [ -e "/home/pi/.PIMAINT.LCK"]
        then
		echo "There may be an issue the maintenance job is still running, deleteing lock file and rebooting."
                sudo rm /home/pi/.PIMAINT.LCK
	fi
	sudo /sbin/shutdown -r now
fi
