#!/bin/bash
set -e
trap ctrl_c INT
function ctrl_c() {
  exit 0
}
rm /tmp/.X1-lock 2> /dev/null &
touch /root/.Xauthority

# Create .vnc directory
mkdir -p ~/.vnc

# Set VNC password
if [ ! -s ~/.vnc/passwd ]; then
  echo "$VNC_PASSWORD" | vncpasswd -f > ~/.vnc/passwd
  chmod 600 ~/.vnc/passwd
  unset VNC_PASSWORD
fi

# Start Xvfb
Xvfb :1 -screen 0 "${VNC_RESOLUTION}x${VNC_COL_DEPTH}" &
export DISPLAY=:1

# Start noVNC
/opt/noVNC/utils/novnc_proxy --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT &

# Start VNC server
vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION -SecurityTypes VncAuth -localhost no &

# Give the VNC server some time to start
sleep 5

wait