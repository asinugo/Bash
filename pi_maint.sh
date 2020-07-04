# !/bin/bash
# Pi Maintenance Script
set +e
echo "Starting PI Maintenance"
cd /home/pi
sudo echo 1 > .PIMAINT.LCK
trap 'rm -f /home/pi/.PIMAINT.LCK; exit $?' INT TERM EXIT
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get autoclean
sudo apt-get clean
sudo apt-get autoremove
sudo rm .PIMAINT.LCK
trap - INT TERM EXIT
set -e
sudo reboot
