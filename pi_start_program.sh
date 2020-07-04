#!/bin/bash
# Startup Script - with restart
echo "Starting the PROGRAM"
cd /home/pi
# Save the last log if we need to look at it later
mv PROGRAM.log PROGRAM.log.last
cd /home/pi/scripts
until python3 PROGRAM.py >> /home/pi/PROGRAM.log; do
	echo "PROGRAM.py crashed with exit code $?. Respawning...." >> /home/pi/PROGRAM.log
	sleep 1
done

