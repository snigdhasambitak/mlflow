#!/bin/bash

BASE_DIR=$(dirname "${BASH_SOURCE:-0}")
K8S_BASE_DIR="${BASE_DIR}"/../kubernetes/environments/local

echo "[INFO] - Getting into Minikube's docker environment"
eval "$(minikube docker-env)"

echo "[INFO] - Building mlflow-tracking-server..."
docker build -t mlflow-tracking-server:latest "${BASE_DIR}"/../mlflow-tracking-server

echo "[INFO] - Exporting env variables"
set -o allexport && \
source "${BASE_DIR}"/../config/k8s-local/gcp_sa.env && \
source "${BASE_DIR}"/../config/k8s-local/mlflow_postgres.env && \
set +o allexport

echo "[INFO] - Deploying the apps to Minikube"
kubectl config use-context minikube
envsubst < "${K8S_BASE_DIR}"/general/namespace.yaml | kubectl apply -f -
envsubst < "${K8S_BASE_DIR}"/general/secrets.yaml | kubectl apply -f -
envsubst < "${K8S_BASE_DIR}"/cloud-sql-proxy/deployment.yaml | kubectl apply -f -
envsubst < "${K8S_BASE_DIR}"/cloud-sql-proxy/service.yaml | kubectl apply -f -
envsubst < "${K8S_BASE_DIR}"/mlflow/configmap.yaml | kubectl apply -f -
envsubst < "${K8S_BASE_DIR}"/mlflow/deployment.yaml | kubectl apply -f -
envsubst < "${K8S_BASE_DIR}"/mlflow/service.yaml | kubectl apply -f -

echo "Done!"
