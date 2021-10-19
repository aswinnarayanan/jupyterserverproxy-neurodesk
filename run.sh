#!/bin/bash

timestamp=$(date +%Y%m%d%H%M%S)

docker build . -t aswinnarayanan/jupyterserverproxy-neurodesk:$timestamp
docker run -it -p 8888:8888 -p 8080:8080 aswinnarayanan/jupyterserverproxy-neurodesk:$timestamp