#!/bin/bash

timestamp=$(date +%Y%m%d%H%M%S)

repo2docker --no-run --image-name aswinnarayanan/jupyterserverproxy-neurodesk:$timestamp r2d

docker push aswinnarayanan/jupyterserverproxy-neurodesk:$timestamp
echo "FROM aswinnarayanan/jupyterserverproxy-neurodesk:$timestamp" > binder/Dockerfile
