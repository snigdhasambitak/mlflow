#!/bin/bash

echo "[INFO] - Destroying all resources for namespace [mlops]"
kubectl config use-context minikube
kubectl delete all --all -n mlops
echo "Done!"
