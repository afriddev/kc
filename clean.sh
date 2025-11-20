#!/bin/bash

set -e

echo "Cleaning up Keycloak deployment..."

echo "Deleting Keycloak resources..."
kubectl delete -f keycloak/keycloak-nodeport-service.yaml --ignore-not-found=true
kubectl delete -f keycloak/keycloak-statefulset.yaml --ignore-not-found=true
kubectl delete -f postgres/postgres-storage-claim.yaml --ignore-not-found=true
kubectl delete -f postgres/postgres-clusterip-service.yaml --ignore-not-found=true
kubectl delete -f postgres/postgres-deployment.yaml --ignore-not-found=true

echo "Waiting for pods to terminate..."
kubectl wait --for=delete pod -l app=keycloak -n his-keycloak --timeout=120s || true

echo "Deleting PVCs..."
kubectl delete pvc -n his-keycloak --all

echo "Deleting storage resources..."
kubectl delete -f pvc/keycloak/keycloak-pv0.yaml --ignore-not-found=true
kubectl delete -f pvc/keycloak/keycloak-pv1.yaml --ignore-not-found=true
kubectl delete -f pvc/postgres/postgres-pv0.yaml --ignore-not-found=true
kubectl delete -f pvc/persistent-volumes.yaml --ignore-not-found=true

echo "Deleting secrets..."
kubectl delete -f secrets/keycloak-secrets.yaml --ignore-not-found=true
kubectl delete -f secrets/postgres-secrets.yaml --ignore-not-found=true

echo "Deleting namespace..."
kubectl delete -f 00-namespace/namespace.yaml --ignore-not-found=true

echo ""
echo "Cleanup complete!"
echo "You can now run ./deploy.sh to redeploy"
