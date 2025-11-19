#!/bin/bash
set -e

NS=his-keycloak

echo "====== Deploying Keycloak HA ======"

kubectl apply -f namespace.yaml
kubectl apply -f storage-class.yaml

kubectl apply -f pv.yaml
kubectl apply -f secrets.yaml

kubectl apply -f postgres/
kubectl wait --for=condition=ready pod -l app=postgres -n $NS --timeout=180s

kubectl apply -f keycloak/
kubectl wait --for=condition=ready pod -l app=keycloak -n $NS --timeout=240s

kubectl get pods -n $NS
kubectl get pvc -n $NS
kubectl get pv

NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')
echo ""
echo "Keycloak URL:  http://$NODE_IP:30801"
echo "Username: admin  Password: admin@123"
echo "Data stored under: /home/alien/keycloak"
