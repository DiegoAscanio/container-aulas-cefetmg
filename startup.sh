#!/bin/bash
# Remove travas do X
rm /tmp/.X0-lock
# iniciar o servidor VNC
/usr/bin/Xvnc -SecurityTypes None &
/usr/bin/sleep 5
# iniciar o NOVNC (VNC no navegador)
/usr/bin/websockify --web=/usr/share/novnc/ 6080 localhost:5900 &
/usr/bin/sleep 5
# iniciar o openbox
DISPLAY=:0 /usr/bin/openbox-session 
