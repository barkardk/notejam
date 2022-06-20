#!/bin/bash 

echo "Note that the .dockerignore manages which files get copied into the docker image"
docker build -t ghcr.io/barkardk/notejam:latest -f Dockerfile .

cat <<EOF
 I pushed to my personal container registry using this
 $ docker push ghcr.io/barkardk/notejam:latest 


 This container is both bloated and runs as root but for demo purposes ok
 Run the container locally to test the app
 $ docker run --rm -p 8000:8000 ghcr.io/barkardk/notejam:latest


Now to install notejam via helm , the values file or other parames can be used for various env settings"
EOF
helm install notejam notejam

cat <<EOF 
notejam is exposed via loadBalancer service, change the values.yaml in kubernetes folder to use another svc

1. Get the application URL by running these commands:
     NOTE: It may take a few minutes for the LoadBalancer IP to be available.
           You can watch the status of by running 'kubectl get --namespace default svc -w notejam'
  export SERVICE_IP=$(kubectl get svc --namespace default notejam --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
  echo http://$SERVICE_IP:80
EOF

echo "Setup monitoring"
helm upgrade --install loki-grafana grafana/grafana --values grafana-values.yaml
helm upgrade --install loki grafana/loki-distributed
## Good example of what a badly configured values.yaml does to a dynamic install parameter aka config.clients[0].url
helm upgrade --install promtail grafana/promtail --set "config.clients[0].url=http://loki-loki-distributed-gateway.default.svc.cluster.local/loki/api/v1/push"

cat <<EOF 
    1. Get the application URL by running these commands:
    echo "Browse to http://localhost:3000"
     kubectl port-forward service/loki-grafana 3000:80

2. Get the admin credentials:

    echo "User: admin"
    echo "Password: $(kubectl get secret loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)"

    If this app was not so old I would have installed django-prometheus middleware and exported metrics to prometheus
    that way
    prometheus is also too large of a deployment for my small mini cluster in GKE  
    so instead I enabled DEBUG mode in django , just to get some logs and shipped them to grafana loki
    NOT what I would reccomend for a live a pplication but for a demo I guess it will do 
EOF

cat <<EOF
#############################################################
TO see some logs in loki open browser at localhost:3000 and login
If you look in data sources loki should already be configured
Go to explore , select label app , select notejam and you should see the debug logs
#############################################################
EOF
