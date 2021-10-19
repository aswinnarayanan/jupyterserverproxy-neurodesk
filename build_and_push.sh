#!/bin/bash

repo2docker --no-run --image-name aswinnarayanan/jupyterserverproxy-neurodesk:latest .
docker push aswinnarayanan/jupyterserverproxy-neurodesk:latest
