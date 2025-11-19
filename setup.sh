#!/bin/bash
set -e

echo "Preparing persistent storage folder for Keycloak and Postgres..."
sudo mkdir -p /home/alien/keycloak/postgres
sudo chmod -R 777 /home/alien/keycloak

echo "✓ /home/alien/keycloak prepared"
echo "Run: ./deploy.sh"
