#!/bin/bash

sudo service ssh restart
# sudo service xrdp restart
# USER=user vncserver -kill :1
# USER=user vncserver -depth 24 -geometry 1920x1080 -name \"VNC\" :1

/home/jovyan/tomcat/bin/startup.sh
guacd -L debug -f &
