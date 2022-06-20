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
helm install grafana bitnami/grafana
helm install loki bitnami/grafana-loki

cat <<EOF 
    1. Get the application URL by running these commands:
    echo "Browse to http://127.0.0.1:8080"
    kubectl port-forward svc/grafana 8080:3000 &

2. Get the admin credentials:

    echo "User: admin"
    echo "Password: $(kubectl get secret grafana-admin --namespace default -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 -d)"

    If this app was not so old I would have installed django-prometheus middleware and exported metrics to prometheus
    that way
    prometheus is also too large of a deployment for my small mini cluster in GKE  
    so instead I enabled DEBUG mode in django , just to get some logs and shipped them to grafana loki
    NOT what I would reccomend for a live a pplication but for a demo I guess it will do 
EOF
