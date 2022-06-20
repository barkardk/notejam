#!/bin/bash 

echo "Note that the .dockerignore manages which files get copied into the docker image"
docker build -t ghcr.io/barkardk/notejam:latest -f Dockerfile .
docker push ghcr.io/barkardk/notejam:latest
echo "This container is both bloated and runs as root but for demo purposes ok"
echo "Run the container locally to test the app"
docker run --rm -p 8000:8000 ghcr.io/barkardk/notejam:latest

echo "install via helm , the values file or other parames can be used for various env settings"
helm install notejam notejam

echo "Setup monitoring"
helm install prometheus  prometheus-community/prometheus 
helm install grafana  prometheus-community/grafana