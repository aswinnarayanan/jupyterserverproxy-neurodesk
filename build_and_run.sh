#!/bin/bash

timestamp=$(date +%Y%m%d%H%M%S)

docker build . -t vnmd/jupyter-remote-desktop-proxy:$timestamp
docker run -it -p 8888:8888 -p 8080:8080 vnmd/jupyter-remote-desktop-proxy:$timestamp