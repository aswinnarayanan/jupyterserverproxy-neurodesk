#!/bin/bash

# sudo service ssh restart
# sudo service xrdp restart

# USER=jovyan vncserver -kill :1
USER=jovyan vncserver -depth 24 -geometry 1920x1080 -name \"VNC\" :1

/home/jovyan/tomcat/bin/startup.sh
guacd -L debug -f &
