#!/bin/bash

set -e

echo "Deploying Keycloak..."

echo "Step 1: Creating namespace..."
kubectl apply -f namespace/namespace.yaml

echo "---------- Creating secrets ----------"
kubectl apply -f secrets/keycloak-secrets.yaml
kubectl apply -f secrets/postgres-secrets.yaml

echo "---------- Creating storage resources ---------"
kubectl apply -f pvc/storage-class.yaml
kubectl apply -f pvc/keycloak/keycloak-pv0.yaml
kubectl apply -f pvc/keycloak/keycloak-pv1.yaml
kubectl apply -f pvc/postgres/postgres-pv0.yaml

echo "---------- Deploying PostgreSQL -----------"
kubectl apply -f postgres/postgres-storage-claim.yaml
kubectl apply -f postgres/postgres-clusterip-service.yaml
kubectl apply -f postgres/postgres-deployment.yaml

echo "---------- Waiting for PostgreSQL to be ready ----------"
kubectl wait --for=condition=ready pod -l component=postgres -n his-keycloak --timeout=300s

echo "---------- Deploying Keycloak StatefulSet ----------"
kubectl apply -f keycloak/keycloak-headless.yaml
kubectl apply -f keycloak/keycloak-clusterip-service.yaml
kubectl apply -f keycloak/keycloak-statefulset.yaml
kubectl apply -f keycloak/keycloak-nodeport-service.yaml

echo "---------- Waiting for Keycloak pods to be ready ----------"
kubectl wait --for=condition=ready pod -l app=keycloak -n his-keycloak --timeout=600s || echo "Timeout - check status with: kubectl get pods -n his-keycloak -w"

echo ""
echo "Deployment complete!"
echo "Check status: kubectl get pods -n his-keycloak"
echo "Access Keycloak: http://104.154.187.72:30100"
