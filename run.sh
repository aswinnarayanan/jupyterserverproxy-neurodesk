#!/bin/bash

docker build . -t aswinnarayanan/jupyterserverproxy-neurodesk:latest
docker run -it -p 8888:8888 -p 8080:8080 aswinnarayanan/jupyterserverproxy-neurodesk:latest