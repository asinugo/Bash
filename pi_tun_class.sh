# Script to create a reverse tunnel so a system can be accessed remotely even if behind a firewall
#!/bin/bash
createTunnel() {
# Edit the following line for your configuration
  /usr/bin/ssh -N -R REMOTEPORT:localhost:22 REMOTEUSER@REMOTE_SERVER_IP
  if [[ $? -eq 0 ]]; then
    echo Tunnel to jumpbox created successfully
  else
    echo An error occurred creating a tunnel to jumpbox. RC was $?
  fi
}
/bin/pidof ssh
if [[ $? -ne 0 ]]; then
  echo Creating new tunnel connection
  createTunnel
fi

# To automatically start and keep it up add this to your crontab
# This assumes the script is in the pi home directory and the log file will be there as well
# */1 * * * * /home/pi/pi_tun_class.sh >> /home/pi/tunnel.log 2>&1
