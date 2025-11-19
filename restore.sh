#!/bin/bash

set -e

echo "Restoring Keycloak from /home/alien/keycloak..."

echo "Deleting existing resources..."
kubectl delete -f 04-keycloak/keycloak-statefulset.yaml --ignore-not-found=true
kubectl delete -f 03-postgres/postgres-deployment.yaml --ignore-not-found=true

echo "Waiting for pods to terminate..."
sleep 10

echo "Redeploying with existing data..."
kubectl apply -f 03-postgres/postgres-deployment.yaml
kubectl wait --for=condition=ready pod -l component=postgres -n keycloak --timeout=300s

kubectl apply -f 04-keycloak/keycloak-statefulset.yaml
kubectl wait --for=condition=ready pod -l component=keycloak -n keycloak --timeout=600s

echo "Restore complete!"
