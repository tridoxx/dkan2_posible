# DKAN2 for Köln in Kubernetes


## Lokale Entwicklung unter Docker

`docker compose up -d
`

`docker exec -it drupal /bin/sh
`

Im Container wird dann für die initiale Entwicklung

`./install.sh` oder nach Anpassung des Frontends bzw. Schemata `./update.sh` aufgerufen.

Diese beiden Scripte sorgen für die Anpassung der jeweiligen Installation
Anhand der CLIENTID Umgebungsvariable aus der docker-compose.yml wird über die beiden Scripte ein Repo in den Container importiert,
das die Schemata und Frontend Assets in die entsprechenden Zielverzeichnisse importiert.
Diese Repos finden sich unter dem `clients` directory.


### Built des Images
`docker build . -t markaspot/dkan2:latest --target=production`


## Kubernetes Installation

Cluster wechseln
`kubectl config set-cluster workshoptest-1 (prod)`

Den Namespace anlegen analog des Mandanten / Projekt
`kubectl create namespace dkan2-client-koeln`

Wenn notwendig Dockerhub Credentials hinterlegen
`kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=holgercgn --docker-password=geheim --docker-email=holger.kreis@stadt-koeln.de`

Namespace für alle Operationen default auswählen

`kubectl config set-context --current --namespace=dkan2-client-koeln`

PVC anlegen

`kubectl apply -f .k8s/volumes/dkan-files.yml`

Configmaps anlegen

`kubectl apply -f .k8s/configmaps/`

Secrets (DB Credentials anlegen)

`kubectl apply -f .k8s/secrets`

Deployment starten

`kubectl apply -f .k8s/deployments/dkan2-deployment.yml --validate=false`

Service veröffentlichen

`kubectl expose deployments dkan2 --type=NodePort --port=80`


## Offene Fragen:

1. Wie kann man den Service so veröffentlichen, dass der Ingress den Namespace einen custom domain-namen annimmt.
