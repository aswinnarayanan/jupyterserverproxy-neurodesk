#!/bin/bash

docker build . -t aswinnarayanan/jupyterserverproxy-neurodesk:latest
docker push aswinnarayanan/jupyterserverproxy-neurodesk:latest