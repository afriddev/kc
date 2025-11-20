#!/bin/bash

set -e

echo "Restoring Keycloak from /home/alien/keycloak..."

echo "---------- Deleting existing resources ----------"
kubectl delete -f keycloak/keycloak-statefulset.yaml --ignore-not-found=true
kubectl delete -f postgres/postgres-deployment.yaml --ignore-not-found=true

echo "---------- Waiting for pods to terminate (10s) ----------"
sleep 10

echo "---------- Redeploying with existing data ----------"
kubectl apply -f postgres/postgres-deployment.yaml
kubectl wait --for=condition=ready pod -l component=postgres -n his-keycloak --timeout=300s

kubectl apply -f keycloak/keycloak-statefulset.yaml
kubectl wait --for=condition=ready pod -l component=keycloak -n his-keycloak --timeout=600s

echo "---------- Restore complete! ----------"
