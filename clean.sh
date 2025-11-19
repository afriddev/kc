#!/bin/bash

set -e

echo "Cleaning up Keycloak deployment..."

echo "Deleting Keycloak resources..."
kubectl delete -f 04-keycloak/keycloak-nodeport-service.yaml --ignore-not-found=true
kubectl delete -f 04-keycloak/keycloak-statefulset.yaml --ignore-not-found=true
kubectl delete -f 03-postgres/postgres-deployment.yaml --ignore-not-found=true

echo "Waiting for pods to terminate..."
kubectl wait --for=delete pod -l app=keycloak -n keycloak --timeout=120s || true

echo "Deleting PVCs..."
kubectl delete pvc -n keycloak --all

echo "Deleting storage resources..."
kubectl delete -f 02-storage/persistent-volumes.yaml --ignore-not-found=true
kubectl delete -f 02-storage/storageclass.yaml --ignore-not-found=true

echo "Deleting secrets..."
kubectl delete -f 01-secrets/secrets.yaml --ignore-not-found=true

echo "Deleting namespace..."
kubectl delete -f 00-namespace/namespace.yaml --ignore-not-found=true

echo ""
echo "Cleanup complete!"
echo "You can now run ./deploy.sh to redeploy"
