#!/bin/bash

set -e

echo "Cleaning Keycloak database..."

# Get the postgres pod name
POSTGRES_POD=$(kubectl get pod -n keycloak -l component=postgres -o jsonpath='{.items[0].metadata.name}')

echo "Found PostgreSQL pod: $POSTGRES_POD"

# Drop and recreate the keycloak database
echo "Dropping keycloak database..."
kubectl exec -n keycloak $POSTGRES_POD -- psql -U keycloak -d postgres -c "DROP DATABASE IF EXISTS keycloak;"

echo "Creating fresh keycloak database..."
kubectl exec -n keycloak $POSTGRES_POD -- psql -U keycloak -d postgres -c "CREATE DATABASE keycloak OWNER keycloak;"

echo ""
echo "Database cleaned successfully!"
echo "Now restart Keycloak:"
echo "  kubectl rollout restart statefulset -n keycloak keycloak"
