#!/bin/bash

# docker build . -t aswinnarayanan/jupyterserverproxy-neurodesk:latest
# docker push aswinnarayanan/jupyterserverproxy-neurodesk:latest

timestamp=$(date +%Y%m%d%H%M%S)

docker build . -t aswinnarayanan/jupyterserverproxy-neurodesk:$timestamp
docker push aswinnarayanan/jupyterserverproxy-neurodesk:$timestamp

echo "FROM aswinnarayanan/jupyterserverproxy-neurodesk:$timestamp" > binder/Dockerfile
