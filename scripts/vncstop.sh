#!/usr/bin/env bash
vncstop() {
  echo -n "Enter port number which you want to kill (Example: 3): "
  read pt
  echo " "
  echo "Killing port $pt"
  vncserver -kill :$pt
  rm -rf /tmp/.X$pt-lock
  rm -rf /tmp/.X11-unix/X$pt
}

vnckill() {
  echo "Killing entire VNC Server"
  killall Xvnc
}

