#!/bin/bash

set -e

echo "Deploying Keycloak..."

echo "Step 1: Creating namespace..."
kubectl apply -f 00-namespace/namespace.yaml

echo "Step 2: Creating secrets..."
kubectl apply -f 01-secrets/secrets.yaml

echo "Step 3: Creating storage resources..."
kubectl apply -f 02-storage/storageclass.yaml
kubectl apply -f 02-storage/persistent-volumes.yaml

echo "Step 4: Deploying PostgreSQL..."
kubectl apply -f 03-postgres/postgres-deployment.yaml

echo "Waiting for PostgreSQL to be ready..."
kubectl wait --for=condition=ready pod -l component=postgres -n keycloak --timeout=300s

echo "Step 5: Deploying Keycloak StatefulSet..."
kubectl apply -f 04-keycloak/keycloak-statefulset.yaml

echo "Waiting for Keycloak pods to be ready..."
kubectl wait --for=condition=ready pod -l component=keycloak -n keycloak --timeout=600s

echo ""
echo "Deployment complete!"
echo ""
echo "Check status with:"
echo "  kubectl get pods -n keycloak"
echo ""
echo "Access Keycloak:"
echo "  kubectl port-forward -n keycloak svc/keycloak 8080:8080"
echo "  Then open: http://localhost:8080"
