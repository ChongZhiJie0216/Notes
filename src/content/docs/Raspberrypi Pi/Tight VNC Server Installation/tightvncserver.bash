#!/bin/bash
### BEGIN INIT INFO
# Provides:          TightVNCServer
# Required-Start:    $syslog
# Required-Stop:     $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: vnc server
# Description:
### END INIT INFO
export USER='pi'
eval cd ~$USER
# Check the state of the command - this'll either be start or stop
case "$1" in
  start)
    # if it's start, then start vncserver using the details below
    su $USER -c '/usr/bin/vncserver :1 -geometry 1920x1080 -depth 16 -pixelformat rgb565'
    echo "Starting TightVNCServer for $USER"
    ;;
  stop)
    # if it's stop, then just kill the process
    pkill Xtightvnc
    echo "TightVNCServer stopped"
    ;;
  *)
    echo "Usage: /etc/init.d/tightvncserver {start|stop}"
    exit 1
    ;;
esac
exit 0